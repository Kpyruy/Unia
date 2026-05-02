import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum LessonOccurrenceStatus {
  missed('missed'),
  cancelled('cancelled');

  const LessonOccurrenceStatus(this.storageValue);

  final String storageValue;

  static LessonOccurrenceStatus? fromStorage(String? value) {
    for (final status in values) {
      if (status.storageValue == value) return status;
    }
    return null;
  }
}

class LessonStatusService {
  static const String storageKey = 'lessonStatusOverrides';

  static Future<Map<String, LessonOccurrenceStatus>> loadStatuses(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const {};
      return Map<String, LessonOccurrenceStatus>.fromEntries(
        decoded.entries.map((entry) {
          final status = LessonOccurrenceStatus.fromStorage(
            entry.value?.toString(),
          );
          if (status == null) return null;
          return MapEntry(entry.key.toString(), status);
        }).whereType<MapEntry<String, LessonOccurrenceStatus>>(),
      );
    } catch (_) {
      return const {};
    }
  }

  static Future<void> setStatus(
    SharedPreferences prefs,
    String key,
    LessonOccurrenceStatus status,
  ) async {
    final statuses = await loadStatuses(prefs);
    final updated = {...statuses, key: status};
    await _saveStatuses(prefs, updated);
  }

  static Future<void> clearStatus(SharedPreferences prefs, String key) async {
    final statuses = await loadStatuses(prefs);
    final updated = {...statuses}..remove(key);
    await _saveStatuses(prefs, updated);
  }

  static String buildKey(Map<dynamic, dynamic> lesson) {
    final date = lesson['date']?.toString() ?? '';
    final manualId = lesson['_manualId']?.toString().trim() ?? '';
    final subject =
        (lesson['_subjectShort'] ??
                lesson['_subjectLong'] ??
                lesson['su'] ??
                '')
            .toString()
            .trim();
    final lessonId = manualId.isNotEmpty ? manualId : subject;
    return [
      date,
      lessonId,
      lesson['startTime']?.toString() ?? '',
      lesson['endTime']?.toString() ?? '',
      subject,
    ].join('|');
  }

  static Future<void> _saveStatuses(
    SharedPreferences prefs,
    Map<String, LessonOccurrenceStatus> statuses,
  ) async {
    final encoded = Map<String, String>.fromEntries(
      statuses.entries.map(
        (entry) => MapEntry(entry.key, entry.value.storageValue),
      ),
    );
    await prefs.setString(storageKey, jsonEncode(encoded));
  }
}
