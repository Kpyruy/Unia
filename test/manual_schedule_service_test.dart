import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unia/services/manual_schedule_service.dart';

void main() {
  test('buildWeek expands recurring manual lessons into selected week', () {
    final monday = DateTime(2026, 5, 4);
    final definitions = [
      const ManualLessonDefinition(
        id: 'math',
        dayIndex: 0,
        startTime: 800,
        endTime: 930,
        subject: 'Mathematics',
        subjectShort: 'MA',
        teacher: 'Ada Lovelace',
        room: 'A101',
      ),
      const ManualLessonDefinition(
        id: 'physics',
        dayIndex: 2,
        startTime: 1000,
        endTime: 1130,
        subject: 'Physics',
        subjectShort: 'PH',
        teacher: '',
        room: 'B202',
      ),
    ];

    final week = ManualScheduleService.buildWeek(monday, definitions);

    expect(week[0], hasLength(1));
    expect(week[0]!.single, {
      '_manualId': 'math',
      'date': 20260504,
      'startTime': 800,
      'endTime': 930,
      '_subjectShort': 'MA',
      '_subjectLong': 'Mathematics',
      '_teacher': 'Ada Lovelace',
      '_room': 'A101',
      'code': '',
    });
    expect(week[2], hasLength(1));
    expect(week[2]!.single['date'], 20260506);
  });

  test(
    'saveDefinitions round trips manual lessons through preferences',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const lesson = ManualLessonDefinition(
        id: 'history',
        dayIndex: 4,
        startTime: 1230,
        endTime: 1400,
        subject: 'History',
        subjectShort: 'HI',
        teacher: 'Grace Hopper',
        room: 'C303',
      );

      await ManualScheduleService.saveDefinitions(prefs, [lesson]);
      final loaded = await ManualScheduleService.loadDefinitions(prefs);

      expect(loaded, [lesson]);
    },
  );

  test('encodeBackupJson writes compact manual timetable backup', () {
    const lesson = ManualLessonDefinition(
      id: 'programming',
      dayIndex: 1,
      startTime: 945,
      endTime: 1115,
      subject: 'Programming',
      subjectShort: 'PRG',
      teacher: 'Alan Turing',
      room: 'D404',
    );

    final raw = ManualScheduleService.encodeBackupJson([lesson]);

    expect(raw, contains('"app":"Unia"'));
    expect(raw, contains('"schemaVersion":1'));
    expect(raw, contains('"manualLessons"'));
    expect(ManualScheduleService.decodeBackupJson(raw), [lesson]);
  });

  test('decodeBackupJson ignores invalid and malformed lesson entries', () {
    const raw =
        '{"app":"Unia","schemaVersion":1,"manualLessons":[{"id":"ok","dayIndex":0,"startTime":800,"endTime":930,"subject":"Math","subjectShort":"MA","teacher":"","room":"A1"},"bad",{"id":"outside","dayIndex":8}]}';

    final decoded = ManualScheduleService.decodeBackupJson(raw);

    expect(decoded, [
      const ManualLessonDefinition(
        id: 'ok',
        dayIndex: 0,
        startTime: 800,
        endTime: 930,
        subject: 'Math',
        subjectShort: 'MA',
        teacher: '',
        room: 'A1',
      ),
    ]);
  });
}
