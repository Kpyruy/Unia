import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unia/services/manual_schedule_service.dart';
import 'package:unia/services/schedule_backup_service.dart';

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
    'writeDefinitions sends compact backup content to native Android',
    () async {
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
      expect(ManualScheduleService.decodeBackupJson(captured!), [lesson]);
    },
  );
}
