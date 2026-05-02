import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unia/services/lesson_status_service.dart';

void main() {
  test('buildKey prefers manual id and includes date', () {
    final key = LessonStatusService.buildKey({
      '_manualId': 'math',
      'date': 20260504,
      'startTime': 800,
      'endTime': 930,
      '_subjectShort': 'MA',
    });

    expect(key, '20260504|math|800|930|MA');
  });

  test('setStatus round trips missed and clears status', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const key = '20260504|math|800|930|MA';

    await LessonStatusService.setStatus(
      prefs,
      key,
      LessonOccurrenceStatus.missed,
    );
    expect(await LessonStatusService.loadStatuses(prefs), {
      key: LessonOccurrenceStatus.missed,
    });

    await LessonStatusService.clearStatus(prefs, key);
    expect(await LessonStatusService.loadStatuses(prefs), isEmpty);
  });
}
