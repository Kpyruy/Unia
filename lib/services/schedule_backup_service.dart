import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manual_schedule_service.dart';

class ScheduleBackupService {
  static const String backupFileName = 'unia_schedule_backup.json';
  static const String backupDirectory = 'Download/Unia';
  static const MethodChannel _channel = MethodChannel('unia/schedule_backup');

  static Future<bool> writeDefinitions(
    List<ManualLessonDefinition> definitions,
  ) async {
    final content = ManualScheduleService.encodeBackupJson(definitions);
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
    final existing = prefs.getStringList(ManualScheduleService.storageKey);
    if (existing != null && existing.isNotEmpty) return false;

    final raw = await readBackupJson();
    if (raw == null || raw.trim().isEmpty) return false;

    final definitions = ManualScheduleService.decodeBackupJson(raw);
    if (definitions.isEmpty) return false;

    await ManualScheduleService.saveDefinitions(prefs, definitions);
    await prefs.setBool('manualMode', true);
    await prefs.setBool('onboardingCompleted', true);
    await prefs.setString('profileName', 'Unia');
    await prefs.setInt('personType', ManualScheduleService.manualPersonType);
    await prefs.setInt('personId', ManualScheduleService.manualPersonId);
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
}
