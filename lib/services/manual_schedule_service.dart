import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManualScheduleService {
  static const int manualPersonType = 5;
  static const int manualPersonId = 900001;
  static const String storageKey = 'manualLessons';
  static const int backupSchemaVersion = 1;

  static Future<List<ManualLessonDefinition>> loadDefinitions(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getStringList(storageKey) ?? const [];
    return raw
        .map((entry) {
          try {
            final decoded = jsonDecode(entry);
            if (decoded is! Map) return null;
            return ManualLessonDefinition.fromJson(
              Map<String, dynamic>.from(decoded),
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<ManualLessonDefinition>()
        .toList()
      ..sort(_compareDefinitions);
  }

  static Future<void> saveDefinitions(
    SharedPreferences prefs,
    List<ManualLessonDefinition> definitions,
  ) async {
    final normalized = [...definitions]..sort(_compareDefinitions);
    await prefs.setStringList(
      storageKey,
      normalized.map((lesson) => jsonEncode(lesson.toJson())).toList(),
    );
  }

  static String encodeBackupJson(List<ManualLessonDefinition> definitions) {
    final normalized = [...definitions]..sort(_compareDefinitions);
    return jsonEncode({
      'app': 'Unia',
      'schemaVersion': backupSchemaVersion,
      'manualLessons': normalized.map((lesson) => lesson.toJson()).toList(),
    });
  }

  static List<ManualLessonDefinition> decodeBackupJson(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return const [];
    final schemaVersion = (decoded['schemaVersion'] as num?)?.toInt();
    if (schemaVersion != backupSchemaVersion && schemaVersion != 2) {
      return const [];
    }
    final lessons = decoded['manualLessons'];
    if (lessons is! List) return const [];

    final definitions = lessons
        .whereType<Map>()
        .map(
          (entry) =>
              ManualLessonDefinition.fromJson(Map<String, dynamic>.from(entry)),
        )
        .where(_isValidBackupDefinition)
        .toList();
    definitions.sort(_compareDefinitions);
    return definitions;
  }

  static Map<int, List<dynamic>> buildWeek(
    DateTime monday,
    List<ManualLessonDefinition> definitions,
  ) {
    final week = {
      0: <dynamic>[],
      1: <dynamic>[],
      2: <dynamic>[],
      3: <dynamic>[],
      4: <dynamic>[],
    };

    final mondayDate = DateTime(monday.year, monday.month, monday.day);
    final weekNumber = _isoWeekNumber(mondayDate);
    for (final lesson in definitions) {
      if (lesson.dayIndex < 0 || lesson.dayIndex > 4) continue;
      if (!lesson.recurrence.includesIsoWeek(weekNumber)) continue;
      final date = mondayDate.add(Duration(days: lesson.dayIndex));
      week[lesson.dayIndex]!.add(lesson.toWeekLesson(date));
    }

    for (final lessons in week.values) {
      lessons.sort((a, b) {
        final aStart = (a['startTime'] as int?) ?? 0;
        final bStart = (b['startTime'] as int?) ?? 0;
        return aStart.compareTo(bStart);
      });
    }

    return week;
  }

  static int _compareDefinitions(
    ManualLessonDefinition a,
    ManualLessonDefinition b,
  ) {
    final byDay = a.dayIndex.compareTo(b.dayIndex);
    if (byDay != 0) return byDay;
    return a.startTime.compareTo(b.startTime);
  }

  static bool _isValidBackupDefinition(ManualLessonDefinition definition) {
    if (definition.id.trim().isEmpty) return false;
    if (definition.dayIndex < 0 || definition.dayIndex > 4) return false;
    if (definition.startTime < 0 || definition.startTime > 2359) return false;
    if (definition.endTime < 0 || definition.endTime > 2359) return false;
    if (definition.endTime <= definition.startTime) return false;
    if (definition.subject.trim().isEmpty) return false;
    return true;
  }

  static int _isoWeekNumber(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final thursday = normalized.add(
      Duration(days: DateTime.thursday - normalized.weekday),
    );
    final firstThursday = DateTime(thursday.year, 1, 4);
    final firstWeekThursday = firstThursday.add(
      Duration(days: DateTime.thursday - firstThursday.weekday),
    );
    return 1 + thursday.difference(firstWeekThursday).inDays ~/ 7;
  }
}

enum ManualLessonRecurrence {
  everyWeek('every_week'),
  oddWeeks('odd_weeks'),
  evenWeeks('even_weeks');

  const ManualLessonRecurrence(this.storageValue);

  final String storageValue;

  static ManualLessonRecurrence fromStorage(String? value) {
    for (final recurrence in values) {
      if (recurrence.storageValue == value) return recurrence;
    }
    return ManualLessonRecurrence.everyWeek;
  }

  bool includesIsoWeek(int weekNumber) {
    return switch (this) {
      ManualLessonRecurrence.everyWeek => true,
      ManualLessonRecurrence.oddWeeks => weekNumber.isOdd,
      ManualLessonRecurrence.evenWeeks => weekNumber.isEven,
    };
  }
}

class ManualLessonDefinition {
  final String id;
  final int dayIndex;
  final int startTime;
  final int endTime;
  final String subject;
  final String subjectShort;
  final String teacher;
  final String room;
  final ManualLessonRecurrence recurrence;

  const ManualLessonDefinition({
    required this.id,
    required this.dayIndex,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.subjectShort,
    required this.teacher,
    required this.room,
    this.recurrence = ManualLessonRecurrence.everyWeek,
  });

  factory ManualLessonDefinition.fromJson(Map<String, dynamic> json) {
    return ManualLessonDefinition(
      id: json['id']?.toString() ?? '',
      dayIndex: (json['dayIndex'] as num?)?.toInt() ?? 0,
      startTime: (json['startTime'] as num?)?.toInt() ?? 800,
      endTime: (json['endTime'] as num?)?.toInt() ?? 845,
      subject: json['subject']?.toString() ?? '',
      subjectShort: json['subjectShort']?.toString() ?? '',
      teacher: json['teacher']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      recurrence: ManualLessonRecurrence.fromStorage(
        json['recurrence']?.toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayIndex': dayIndex,
    'startTime': startTime,
    'endTime': endTime,
    'subject': subject,
    'subjectShort': subjectShort,
    'teacher': teacher,
    'room': room,
    'recurrence': recurrence.storageValue,
  };

  Map<String, dynamic> toWeekLesson(DateTime date) => {
    '_manualId': id,
    'date': int.parse(DateFormat('yyyyMMdd').format(date)),
    'startTime': startTime,
    'endTime': endTime,
    '_subjectShort': subjectShort,
    '_subjectLong': subject,
    '_teacher': teacher,
    '_room': room,
    'code': '',
  };

  ManualLessonDefinition copyWith({
    String? id,
    int? dayIndex,
    int? startTime,
    int? endTime,
    String? subject,
    String? subjectShort,
    String? teacher,
    String? room,
    ManualLessonRecurrence? recurrence,
  }) {
    return ManualLessonDefinition(
      id: id ?? this.id,
      dayIndex: dayIndex ?? this.dayIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      subjectShort: subjectShort ?? this.subjectShort,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
      recurrence: recurrence ?? this.recurrence,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ManualLessonDefinition &&
            id == other.id &&
            dayIndex == other.dayIndex &&
            startTime == other.startTime &&
            endTime == other.endTime &&
            subject == other.subject &&
            subjectShort == other.subjectShort &&
            teacher == other.teacher &&
            room == other.room &&
            recurrence == other.recurrence;
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayIndex,
    startTime,
    endTime,
    subject,
    subjectShort,
    teacher,
    room,
    recurrence,
  );
}
