import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unia/services/manual_schedule_service.dart';
import 'package:unia/services/schedule_backup_service.dart';
import 'package:unia/services/study_task_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('unia/schedule_backup');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('restoreIfNeeded imports backup into empty preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const lesson = ManualLessonDefinition(
      id: 'database',
      dayIndex: 3,
      startTime: 1145,
      endTime: 1315,
      subject: 'Databases',
      subjectShort: 'DB',
      teacher: 'Edgar Codd',
      room: 'E505',
    );
    final backup = ManualScheduleService.encodeBackupJson([lesson]);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'readScheduleBackup');
          return backup;
        });

    final restored = await ScheduleBackupService.restoreIfNeeded(prefs);

    expect(restored, isTrue);
    expect(prefs.getBool('manualMode'), isTrue);
    expect(prefs.getBool('onboardingCompleted'), isTrue);
    expect(await ManualScheduleService.loadDefinitions(prefs), [lesson]);
  });

  test(
    'restoreIfNeeded imports startup settings even when timetable is empty',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const backup = '''
{"app":"Unia","schemaVersion":2,"manualLessons":[],"startup":{"appLocale":"sk","themeMode":2,"backgroundAnimations":false,"backgroundAnimationStyle":5,"backgroundGyroscope":true,"blurEnabled":false,"showCancelled":false,"progressivePush":false,"dailyBriefingPush":false,"importantChangesPush":false,"profileName":"Unia","personType":5,"personId":900001,"aiProvider":"custom","aiModel":"gpt-4o","aiCustomCompatibility":"openai","aiCustomBaseUrl":"https://api.example.test/v1","aiSystemPromptTemplate":"Use my timetable."}}
''';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'readScheduleBackup');
            return backup;
          });

      final restored = await ScheduleBackupService.restoreIfNeeded(prefs);

      expect(restored, isTrue);
      expect(prefs.getBool('manualMode'), isTrue);
      expect(prefs.getBool('onboardingCompleted'), isTrue);
      expect(prefs.getBool('tutorialCompleted'), isTrue);
      expect(prefs.getString('appLocale'), 'sk');
      expect(prefs.getInt('themeMode'), 2);
      expect(prefs.getBool('backgroundAnimations'), isFalse);
      expect(prefs.getInt('backgroundAnimationStyle'), 5);
      expect(prefs.getBool('backgroundGyroscope'), isTrue);
      expect(prefs.getBool('blurEnabled'), isFalse);
      expect(prefs.getBool('showCancelled'), isFalse);
      expect(prefs.getBool('progressivePush'), isFalse);
      expect(prefs.getBool('dailyBriefingPush'), isFalse);
      expect(prefs.getBool('importantChangesPush'), isFalse);
      expect(prefs.getString('aiProvider'), 'custom');
      expect(prefs.getString('aiModel'), 'gpt-4o');
      expect(prefs.getString('aiCustomBaseUrl'), 'https://api.example.test/v1');
      expect(await ManualScheduleService.loadDefinitions(prefs), isEmpty);
    },
  );

  test(
    'writeDefinitions sends compact backup content to native Android',
    () async {
      SharedPreferences.setMockInitialValues({
        'appLocale': 'sk',
        'themeMode': 2,
      });
      const lesson = ManualLessonDefinition(
        id: 'networks',
        dayIndex: 2,
        startTime: 800,
        endTime: 930,
        subject: 'Networks',
        subjectShort: 'NET',
        teacher: '',
        room: 'N1',
      );
      String? captured;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'writeScheduleBackup');
            captured = (call.arguments as Map)['content'] as String;
            return true;
          });

      final saved = await ScheduleBackupService.writeDefinitions([lesson]);

      expect(saved, isTrue);
      expect(captured, isNotNull);
      final decoded = jsonDecode(captured!) as Map<String, dynamic>;
      expect(decoded['schemaVersion'], 3);
      expect(decoded['startup'], containsPair('appLocale', 'sk'));
      expect(decoded['startup'], containsPair('themeMode', 2));
      expect(ManualScheduleService.decodeBackupJson(captured!), [lesson]);
    },
  );

  test(
    'writeCurrentState preserves existing backed up lessons when local schedule is empty',
    () async {
      SharedPreferences.setMockInitialValues({'manualLessons': <String>[]});
      final prefs = await SharedPreferences.getInstance();
      const lesson = ManualLessonDefinition(
        id: 'algorithms',
        dayIndex: 1,
        startTime: 945,
        endTime: 1115,
        subject: 'Algorithms',
        subjectShort: 'ALG',
        teacher: '',
        room: 'A2',
      );
      final existingBackup = ScheduleBackupService.encodeBackupJson(prefs, [
        lesson,
      ]);
      String? captured;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'readScheduleBackup') return existingBackup;
            expect(call.method, 'writeScheduleBackup');
            captured = (call.arguments as Map)['content'] as String;
            return true;
          });

      final saved = await ScheduleBackupService.writeCurrentState(prefs);

      expect(saved, isTrue);
      expect(ManualScheduleService.decodeBackupJson(captured!), [lesson]);
    },
  );

  test('restoreIfNeeded imports study tasks from backup', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const task = StudyTask(
      id: 'archive-task',
      title: 'Finished lab',
      subject: 'Programming',
      dueDate: 20260508,
      notes: 'Submit report',
      priority: StudyTaskPriority.high,
      status: StudyTaskStatus.done,
    );
    final backup = ScheduleBackupService.encodeBackupJson(
      prefs,
      const [],
      tasks: const [task],
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'readScheduleBackup');
          return backup;
        });

    final restored = await ScheduleBackupService.restoreIfNeeded(prefs);

    expect(restored, isTrue);
    expect(await StudyTaskService.loadTasks(prefs), [task]);
  });

  test('writeCurrentState includes study tasks in backup content', () async {
    const task = StudyTask(
      id: 'homework',
      title: 'Homework',
      subject: 'Math',
      dueDate: 20260510,
      notes: '',
      priority: StudyTaskPriority.normal,
      status: StudyTaskStatus.todo,
    );
    SharedPreferences.setMockInitialValues({
      StudyTaskService.storageKey: [jsonEncode(task.toJson())],
    });
    final prefs = await SharedPreferences.getInstance();
    String? captured;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'readScheduleBackup') return null;
          expect(call.method, 'writeScheduleBackup');
          captured = (call.arguments as Map)['content'] as String;
          return true;
        });

    final saved = await ScheduleBackupService.writeCurrentState(prefs);

    expect(saved, isTrue);
    final decoded = jsonDecode(captured!) as Map<String, dynamic>;
    expect(decoded['studyTasks'], [task.toJson()]);
  });

  test('writeCurrentState includes custom exams in backup content', () async {
    final exam = {
      'subject': 'Physics',
      'examType': 'Final',
      'date': 20260602,
      'description': 'Chapters 1-5',
      '_custom': true,
    };
    SharedPreferences.setMockInitialValues({
      ScheduleBackupService.customExamsKey: [jsonEncode(exam)],
    });
    final prefs = await SharedPreferences.getInstance();
    String? captured;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'readScheduleBackup') return null;
          expect(call.method, 'writeScheduleBackup');
          captured = (call.arguments as Map)['content'] as String;
          return true;
        });

    final saved = await ScheduleBackupService.writeCurrentState(prefs);

    expect(saved, isTrue);
    final decoded = jsonDecode(captured!) as Map<String, dynamic>;
    expect(decoded['customExams'], [exam]);
  });

  test('importBackupJson imports lessons, tasks, exams, and startup settings', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const lesson = ManualLessonDefinition(
      id: 'security',
      dayIndex: 4,
      startTime: 1330,
      endTime: 1500,
      subject: 'Security',
      subjectShort: 'SEC',
      teacher: 'Ada Lovelace',
      room: 'S404',
    );
    const task = StudyTask(
      id: 'task-security',
      title: 'Prepare slides',
      subject: 'Security',
      dueDate: 20260601,
      notes: 'Include examples',
      priority: StudyTaskPriority.high,
      status: StudyTaskStatus.inProgress,
    );
    final exam = {
      'subject': 'Security',
      'examType': 'Oral exam',
      'date': '20260612',
      'description': 'All lectures',
      '_custom': true,
    };
    final raw = ScheduleBackupService.encodeBackupJson(
      prefs,
      const [lesson],
      tasks: const [task],
      customExams: [exam],
    );

    final imported = await ScheduleBackupService.importBackupJson(prefs, raw);

    expect(imported, isTrue);
    expect(await ManualScheduleService.loadDefinitions(prefs), [lesson]);
    expect(await StudyTaskService.loadTasks(prefs), [task]);
    expect(prefs.getStringList(ScheduleBackupService.customExamsKey), [
      jsonEncode(exam),
    ]);
    expect(prefs.getBool('manualMode'), isTrue);
    expect(prefs.getBool('onboardingCompleted'), isTrue);
  });

  test('exportCurrentStateJson returns full study data payload', () async {
    const lesson = ManualLessonDefinition(
      id: 'math',
      dayIndex: 0,
      startTime: 800,
      endTime: 930,
      subject: 'Math',
      subjectShort: 'M',
      teacher: '',
      room: 'M1',
    );
    final exam = {
      'subject': 'Math',
      'examType': 'Quiz',
      'date': 20260520,
      'description': '',
      '_custom': true,
    };
    SharedPreferences.setMockInitialValues({
      ManualScheduleService.storageKey: [jsonEncode(lesson.toJson())],
      ScheduleBackupService.customExamsKey: [jsonEncode(exam)],
      'appLocale': 'en',
    });
    final prefs = await SharedPreferences.getInstance();

    final raw = await ScheduleBackupService.exportCurrentStateJson(prefs);

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    expect(decoded['schemaVersion'], 3);
    expect(decoded['manualLessons'], [lesson.toJson()]);
    expect(decoded['customExams'], [exam]);
    expect(decoded['startup'], containsPair('appLocale', 'en'));
  });
}
