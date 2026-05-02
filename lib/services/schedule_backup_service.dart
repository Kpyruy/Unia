import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manual_schedule_service.dart';
import 'study_task_service.dart';

class ScheduleBackupService {
  static const String backupFileName = 'unia_schedule_backup.json';
  static const String backupDirectory = 'Download/Unia';
  static const String customExamsKey = 'customExams';
  static const MethodChannel _channel = MethodChannel('unia/schedule_backup');
  static const int backupSchemaVersion = 3;

  static Future<bool> writeDefinitions(
    List<ManualLessonDefinition> definitions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return writeCurrentState(
      prefs,
      definitions: definitions,
      preserveExistingLessonsWhenEmpty: false,
      preserveExistingExamsWhenEmpty: false,
    );
  }

  static Future<bool> writeCurrentState(
    SharedPreferences prefs, {
    List<ManualLessonDefinition>? definitions,
    List<StudyTask>? tasks,
    List<Map<String, dynamic>>? customExams,
    bool preserveExistingLessonsWhenEmpty = true,
    bool preserveExistingTasksWhenEmpty = true,
    bool preserveExistingExamsWhenEmpty = true,
  }) async {
    var lessons =
        definitions ?? await ManualScheduleService.loadDefinitions(prefs);
    if (lessons.isEmpty && preserveExistingLessonsWhenEmpty) {
      lessons = await _readExistingBackupDefinitions();
    }
    var studyTasks = tasks ?? await StudyTaskService.loadTasks(prefs);
    if (studyTasks.isEmpty && preserveExistingTasksWhenEmpty) {
      studyTasks = await _readExistingBackupTasks();
    }
    var exams = customExams ?? loadCustomExams(prefs);
    if (exams.isEmpty && preserveExistingExamsWhenEmpty) {
      exams = await _readExistingBackupExams();
    }
    final content = encodeBackupJson(
      prefs,
      lessons,
      tasks: studyTasks,
      customExams: exams,
    );
    return _writeBackupJson(content);
  }

  static Future<String> exportCurrentStateJson(
    SharedPreferences prefs, {
    List<ManualLessonDefinition>? definitions,
    List<StudyTask>? tasks,
    List<Map<String, dynamic>>? customExams,
  }) async {
    return encodeBackupJson(
      prefs,
      definitions ?? await ManualScheduleService.loadDefinitions(prefs),
      tasks: tasks ?? await StudyTaskService.loadTasks(prefs),
      customExams: customExams ?? loadCustomExams(prefs),
    );
  }

  static String encodeBackupJson(
    SharedPreferences prefs,
    List<ManualLessonDefinition> definitions, {
    List<StudyTask> tasks = const [],
    List<Map<String, dynamic>> customExams = const [],
  }) {
    final normalized = [...definitions]
      ..sort((a, b) {
        final byDay = a.dayIndex.compareTo(b.dayIndex);
        if (byDay != 0) return byDay;
        return a.startTime.compareTo(b.startTime);
    });
    final normalizedTasks = [...tasks]..sort(StudyTaskService.compareTasks);
    final normalizedExams = _normalizeCustomExams(customExams);
    return jsonEncode({
      'app': 'Unia',
      'schemaVersion': backupSchemaVersion,
      'manualLessons': normalized.map((lesson) => lesson.toJson()).toList(),
      'studyTasks': normalizedTasks.map((task) => task.toJson()).toList(),
      'customExams': normalizedExams,
      'startup': _startupSettingsFromPrefs(prefs),
    });
  }

  static Future<bool> _writeBackupJson(String content) async {
    try {
      return await _channel.invokeMethod<bool>('writeScheduleBackup', {
            'content': content,
          }) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool> restoreIfNeeded(SharedPreferences prefs) async {
    if (prefs.getBool('onboardingCompleted') == true) return false;

    final existing = prefs.getStringList(ManualScheduleService.storageKey);
    if (existing != null && existing.isNotEmpty) return false;

    final raw = await readBackupJson();
    if (raw == null || raw.trim().isEmpty) return false;

    final restored = await importBackupJson(
      prefs,
      raw,
      writePersistentBackup: false,
    );
    return restored;
  }

  static Future<bool> importBackupJson(
    SharedPreferences prefs,
    String raw, {
    bool writePersistentBackup = true,
  }) async {
    final payload = _decodeBackupJson(raw);
    if (!payload.hasRestorableData) return false;

    await ManualScheduleService.saveDefinitions(prefs, payload.definitions);
    await StudyTaskService.saveTasks(prefs, payload.tasks);
    await saveCustomExams(prefs, payload.customExams);
    await _restoreStartupSettings(prefs, payload.startup);
    await prefs.setBool('onboardingCompleted', true);
    await prefs.setBool('tutorialCompleted', true);
    await prefs.setBool('manualMode', true);
    await prefs.setString(
      'profileName',
      (prefs.getString('profileName') ?? '').trim().isEmpty
          ? 'Unia'
          : prefs.getString('profileName')!,
    );
    await prefs.setInt('personType', ManualScheduleService.manualPersonType);
    await prefs.setInt('personId', ManualScheduleService.manualPersonId);
    if (writePersistentBackup) {
      await writeCurrentState(
        prefs,
        definitions: payload.definitions,
        tasks: payload.tasks,
        customExams: payload.customExams,
        preserveExistingLessonsWhenEmpty: false,
        preserveExistingTasksWhenEmpty: false,
        preserveExistingExamsWhenEmpty: false,
      );
    }
    return true;
  }

  static Future<String?> readBackupJson() async {
    try {
      return await _channel.invokeMethod<String>('readScheduleBackup');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static _ScheduleBackupPayload _decodeBackupJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const _ScheduleBackupPayload.empty();
      final map = Map<String, dynamic>.from(decoded);
      final schemaVersion = (map['schemaVersion'] as num?)?.toInt();
      if (schemaVersion != ManualScheduleService.backupSchemaVersion &&
          schemaVersion != 2 &&
          schemaVersion != backupSchemaVersion) {
        return const _ScheduleBackupPayload.empty();
      }

      final definitions = ManualScheduleService.decodeBackupJson(raw);
      final tasks = _decodeStudyTasks(map['studyTasks']);
      final exams = _decodeCustomExams(map['customExams']);
      final startup = map['startup'] is Map
          ? Map<String, dynamic>.from(map['startup'] as Map)
          : const <String, dynamic>{};
      return _ScheduleBackupPayload(
        definitions: definitions,
        tasks: tasks,
        customExams: exams,
        startup: startup,
        hasStartup: startup.isNotEmpty,
      );
    } catch (_) {
      return const _ScheduleBackupPayload.empty();
    }
  }

  static Future<List<ManualLessonDefinition>>
  _readExistingBackupDefinitions() async {
    final raw = await readBackupJson();
    if (raw == null || raw.trim().isEmpty) return const [];
    return _decodeBackupJson(raw).definitions;
  }

  static Future<List<StudyTask>> _readExistingBackupTasks() async {
    final raw = await readBackupJson();
    if (raw == null || raw.trim().isEmpty) return const [];
    return _decodeBackupJson(raw).tasks;
  }

  static Future<List<Map<String, dynamic>>> _readExistingBackupExams() async {
    final raw = await readBackupJson();
    if (raw == null || raw.trim().isEmpty) return const [];
    return _decodeBackupJson(raw).customExams;
  }

  static List<StudyTask> _decodeStudyTasks(dynamic rawTasks) {
    if (rawTasks is! List) return const [];
    final tasks = rawTasks
        .whereType<Map>()
        .map((entry) => StudyTask.fromJson(Map<String, dynamic>.from(entry)))
        .where(
          (task) => task.id.trim().isNotEmpty && task.title.trim().isNotEmpty,
        )
        .toList();
    tasks.sort(StudyTaskService.compareTasks);
    return tasks;
  }

  static List<Map<String, dynamic>> loadCustomExams(SharedPreferences prefs) {
    final raw = prefs.getStringList(customExamsKey) ?? const [];
    return raw
        .map((entry) {
          try {
            final decoded = jsonDecode(entry);
            if (decoded is! Map) return null;
            return Map<String, dynamic>.from(decoded);
          } catch (_) {
            return null;
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  static Future<void> saveCustomExams(
    SharedPreferences prefs,
    List<Map<String, dynamic>> exams,
  ) async {
    final normalized = _normalizeCustomExams(exams);
    await prefs.setStringList(
      customExamsKey,
      normalized.map((exam) => jsonEncode(exam)).toList(),
    );
  }

  static List<Map<String, dynamic>> _decodeCustomExams(dynamic rawExams) {
    if (rawExams is! List) return const [];
    return _normalizeCustomExams(
      rawExams
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList(),
    );
  }

  static List<Map<String, dynamic>> _normalizeCustomExams(
    List<Map<String, dynamic>> exams,
  ) {
    final normalized = exams
        .map((exam) {
          final subject = (exam['subject'] ?? exam['title'] ?? '')
              .toString()
              .trim();
          final rawDate = exam['date'] ?? exam['examDate'] ?? exam['startDate'];
          final date = rawDate?.toString().replaceAll('-', '').trim();
          if (subject.isEmpty || date == null || date.length != 8) {
            return null;
          }
          return <String, dynamic>{
            'subject': subject,
            'examType': (exam['examType'] ?? exam['type'] ?? 'Exam')
                .toString()
                .trim(),
            'date': rawDate is num ? rawDate.toInt() : date,
            'description': (exam['description'] ?? '').toString().trim(),
            '_custom': true,
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();
    normalized.sort((a, b) {
      final byDate = a['date'].toString().compareTo(b['date'].toString());
      if (byDate != 0) return byDate;
      return (a['subject'] as String).compareTo(b['subject'] as String);
    });
    return normalized;
  }

  static Map<String, dynamic> _startupSettingsFromPrefs(
    SharedPreferences prefs,
  ) {
    return {
      'appLocale': _validLocale(prefs.getString('appLocale') ?? 'en'),
      'themeMode': (prefs.getInt('themeMode') ?? 0).clamp(0, 2),
      'backgroundAnimations': prefs.getBool('backgroundAnimations') ?? true,
      'backgroundAnimationStyle':
          (prefs.getInt('backgroundAnimationStyle') ?? 0).clamp(0, 9),
      'backgroundGyroscope': prefs.getBool('backgroundGyroscope') ?? false,
      'blurEnabled': prefs.getBool('blurEnabled') ?? true,
      'showCancelled': prefs.getBool('showCancelled') ?? true,
      'progressivePush': prefs.getBool('progressivePush') ?? true,
      'dailyBriefingPush': prefs.getBool('dailyBriefingPush') ?? true,
      'importantChangesPush': prefs.getBool('importantChangesPush') ?? true,
      'manualMode': true,
      'profileName': _nonEmptyString(prefs.getString('profileName'), 'Unia'),
      'personType':
          prefs.getInt('personType') ?? ManualScheduleService.manualPersonType,
      'personId':
          prefs.getInt('personId') ?? ManualScheduleService.manualPersonId,
      'aiProvider': _validAiProvider(prefs.getString('aiProvider') ?? 'gemini'),
      'aiModel': (prefs.getString('aiModel') ?? '').trim(),
      'aiCustomCompatibility': _validAiCustomCompatibility(
        prefs.getString('aiCustomCompatibility') ?? 'openai',
      ),
      'aiCustomBaseUrl': (prefs.getString('aiCustomBaseUrl') ?? '').trim(),
      'aiSystemPromptTemplate': prefs.getString('aiSystemPromptTemplate') ?? '',
    };
  }

  static Future<void> _restoreStartupSettings(
    SharedPreferences prefs,
    Map<String, dynamic> startup,
  ) async {
    await prefs.setString(
      'appLocale',
      _validLocale(startup['appLocale']?.toString() ?? 'en'),
    );
    await prefs.setInt(
      'themeMode',
      ((startup['themeMode'] as num?)?.toInt() ?? 0).clamp(0, 2),
    );
    await prefs.setBool(
      'backgroundAnimations',
      startup['backgroundAnimations'] is bool
          ? startup['backgroundAnimations'] as bool
          : true,
    );
    await prefs.setInt(
      'backgroundAnimationStyle',
      ((startup['backgroundAnimationStyle'] as num?)?.toInt() ?? 0).clamp(0, 9),
    );
    await prefs.setBool(
      'backgroundGyroscope',
      startup['backgroundGyroscope'] is bool
          ? startup['backgroundGyroscope'] as bool
          : false,
    );
    await prefs.setBool(
      'blurEnabled',
      startup['blurEnabled'] is bool ? startup['blurEnabled'] as bool : true,
    );
    await prefs.setBool(
      'showCancelled',
      startup['showCancelled'] is bool
          ? startup['showCancelled'] as bool
          : true,
    );
    await prefs.setBool(
      'progressivePush',
      startup['progressivePush'] is bool
          ? startup['progressivePush'] as bool
          : true,
    );
    await prefs.setBool(
      'dailyBriefingPush',
      startup['dailyBriefingPush'] is bool
          ? startup['dailyBriefingPush'] as bool
          : true,
    );
    await prefs.setBool(
      'importantChangesPush',
      startup['importantChangesPush'] is bool
          ? startup['importantChangesPush'] as bool
          : true,
    );
    await prefs.setString(
      'profileName',
      (startup['profileName']?.toString() ?? 'Unia').trim().isEmpty
          ? 'Unia'
          : startup['profileName'].toString().trim(),
    );
    await prefs.setInt(
      'personType',
      (startup['personType'] as num?)?.toInt() ??
          ManualScheduleService.manualPersonType,
    );
    await prefs.setInt(
      'personId',
      (startup['personId'] as num?)?.toInt() ??
          ManualScheduleService.manualPersonId,
    );
    await prefs.setString(
      'aiProvider',
      _validAiProvider(startup['aiProvider']?.toString() ?? 'gemini'),
    );
    final model = (startup['aiModel']?.toString() ?? '').trim();
    if (model.isNotEmpty) await prefs.setString('aiModel', model);
    await prefs.setString(
      'aiCustomCompatibility',
      _validAiCustomCompatibility(
        startup['aiCustomCompatibility']?.toString() ?? 'openai',
      ),
    );
    await prefs.setString(
      'aiCustomBaseUrl',
      (startup['aiCustomBaseUrl']?.toString() ?? '').trim(),
    );
    await prefs.setString(
      'aiSystemPromptTemplate',
      startup['aiSystemPromptTemplate']?.toString() ?? '',
    );
  }

  static String _validLocale(String value) {
    return value == 'sk' ? 'sk' : 'en';
  }

  static String _nonEmptyString(String? value, String fallback) {
    final normalized = (value ?? '').trim();
    return normalized.isEmpty ? fallback : normalized;
  }

  static String _validAiProvider(String value) {
    const supported = {'gemini', 'openai', 'mistral', 'custom'};
    return supported.contains(value) ? value : 'gemini';
  }

  static String _validAiCustomCompatibility(String value) {
    return value == 'gemini' ? 'gemini' : 'openai';
  }
}

class _ScheduleBackupPayload {
  const _ScheduleBackupPayload({
    required this.definitions,
    required this.tasks,
    required this.customExams,
    required this.startup,
    required this.hasStartup,
  });

  const _ScheduleBackupPayload.empty()
    : definitions = const [],
      tasks = const [],
      customExams = const [],
      startup = const {},
      hasStartup = false;

  final List<ManualLessonDefinition> definitions;
  final List<StudyTask> tasks;
  final List<Map<String, dynamic>> customExams;
  final Map<String, dynamic> startup;
  final bool hasStartup;

  bool get hasRestorableData =>
      definitions.isNotEmpty ||
      tasks.isNotEmpty ||
      customExams.isNotEmpty ||
      hasStartup;
}
