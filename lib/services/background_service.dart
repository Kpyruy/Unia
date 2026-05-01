import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../core/time_utils.dart';

import 'manual_schedule_service.dart';
import 'notification_service.dart';

const String kTimetableUpdateTask = 'update_timetable_task';
const String kGithubUpdateCheckTask = 'check_github_updates_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationService().init();
      if (task == kGithubUpdateCheckTask) {
        await checkGithubUpdateAndNotify();
      } else {
        await updateScheduleData();
      }
    } catch (_) {}
    return Future.value(true);
  });
}

class BackgroundService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      "unia_timetable_notification_update",
      kTimetableUpdateTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );

    Workmanager().registerPeriodicTask(
      'untis_github_update_check',
      kGithubUpdateCheckTask,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

List<int> _extractVersionParts(String input) {
  final cleaned = input.trim().replaceFirst(RegExp(r'^[vV]'), '');
  final matches = RegExp(r'\d+').allMatches(cleaned);
  if (matches.isEmpty) return const [0];
  return matches
      .map((m) => int.tryParse(m.group(0) ?? '0') ?? 0)
      .toList(growable: false);
}

int _compareVersionStrings(String current, String latest) {
  final currentParts = _extractVersionParts(current);
  final latestParts = _extractVersionParts(latest);
  final maxLen = math.max(currentParts.length, latestParts.length);
  for (var i = 0; i < maxLen; i++) {
    final a = i < currentParts.length ? currentParts[i] : 0;
    final b = i < latestParts.length ? latestParts[i] : 0;
    if (a == b) continue;
    return a.compareTo(b);
  }
  return 0;
}

String _localizedUpdateTitle(String locale) {
  switch (locale) {
    case 'sk':
      return 'Dostupna aktualizacia Unia';
    case 'en':
    default:
      return 'Unia Update available';
  }
}

String _localizedDailyBriefingTitle(String locale) {
  switch (locale) {
    case 'sk':
      return 'Prehlad dna';
    case 'en':
    default:
      return 'Your day at a glance';
  }
}

String _localizedDailyBriefingBody(
  String locale, {
  required String firstStart,
  required String lastEnd,
  required int lessonCount,
  required int breakCount,
}) {
  switch (locale) {
    case 'sk':
      return '$firstStart-$lastEnd, $lessonCount hodin, $breakCount prestavok';
    case 'en':
    default:
      return '$firstStart-$lastEnd, $lessonCount lessons, $breakCount breaks';
  }
}

String _localizedDailyBriefingExpanded(
  String locale, {
  required String firstStart,
  required String lastEnd,
  required int lessonCount,
  required int breakCount,
  required String nextLesson,
}) {
  switch (locale) {
    case 'sk':
      return 'Zaciatok: $firstStart\nKoniec: $lastEnd\nHodiny: $lessonCount\nPrestávky: $breakCount\nDalsia: $nextLesson';
    case 'en':
    default:
      return 'Start: $firstStart\nEnd: $lastEnd\nLessons: $lessonCount\nBreaks: $breakCount\nNext: $nextLesson';
  }
}

String _localizedImportantChangesTitle(String locale) {
  switch (locale) {
    case 'sk':
      return 'Rozvrh bol aktualizovany';
    case 'en':
    default:
      return 'Timetable updated';
  }
}

String _localizedImportantChangesBody(String locale) {
  switch (locale) {
    case 'sk':
      return 'Dnes su nove zmeny. Klepnutim otvorite rozvrh.';
    case 'en':
    default:
      return 'There are new changes today. Tap to open your timetable.';
  }
}

String _localizedStatusCurrentLesson(String locale) {
  switch (locale) {
    case 'sk':
      return 'Aktualna hodina';
    case 'en':
    default:
      return 'Current lesson';
  }
}

String _localizedStatusNextLesson(String locale) {
  switch (locale) {
    case 'sk':
      return 'Dalsia hodina';
    case 'en':
    default:
      return 'Next lesson';
  }
}

String _localizedStatusNoClasses(String locale) {
  switch (locale) {
    case 'sk':
      return 'Ziadne dalsie hodiny';
    case 'en':
    default:
      return 'No more classes';
  }
}

String _localizedLessonStartsAt(String locale, String start) {
  switch (locale) {
    case 'sk':
      return 'Zacina o $start';
    case 'en':
    default:
      return 'Starts at $start';
  }
}

String _localizedUntilTime(String locale, String end) {
  switch (locale) {
    case 'sk':
      return 'Do $end';
    case 'en':
    default:
      return 'Until $end';
  }
}

String _localizedThen(String locale, String nextLesson) {
  switch (locale) {
    case 'sk':
      return 'Potom: $nextLesson';
    case 'en':
    default:
      return 'Then: $nextLesson';
  }
}

String _localizedClosedLabel(String locale) {
  switch (locale) {
    case 'sk':
      return 'Koniec';
    case 'en':
    default:
      return 'Finished';
  }
}

String _localizedFreeLabel(String locale) {
  switch (locale) {
    case 'sk':
      return 'Volna hodina';
    case 'en':
    default:
      return 'Free period';
  }
}

String _localizedFallbackLessonName(String locale, String start, String end) {
  switch (locale) {
    case 'sk':
      return 'Hodina $start - $end';
    case 'en':
    default:
      return 'Lesson $start - $end';
  }
}

Map<String, int> _detectChangeCounts({
  required String previousSignature,
  required String currentSignature,
}) {
  if (previousSignature.trim().isEmpty) {
    return const {'cancelled': 0, 'room': 0, 'substitution': 0, 'other': 0};
  }

  List<dynamic> previousLessons;
  List<dynamic> currentLessons;
  try {
    previousLessons = jsonDecode(previousSignature) as List<dynamic>;
    currentLessons = jsonDecode(currentSignature) as List<dynamic>;
  } catch (_) {
    return const {'cancelled': 0, 'room': 0, 'substitution': 0, 'other': 1};
  }

  String keyFor(Map<dynamic, dynamic> lesson) {
    final start = lesson['startTime']?.toString() ?? '';
    final end = lesson['endTime']?.toString() ?? '';
    final su = lesson['su']?.toString() ?? '';
    return '$start|$end|$su';
  }

  final previousMap = <String, Map<dynamic, dynamic>>{};
  for (final lesson in previousLessons) {
    if (lesson is Map) {
      previousMap[keyFor(lesson)] = lesson;
    }
  }

  var cancelled = 0;
  var room = 0;
  var substitution = 0;
  var other = 0;

  for (final lesson in currentLessons) {
    if (lesson is! Map) continue;
    final key = keyFor(lesson);
    final prev = previousMap[key];
    if (prev == null) {
      other++;
      continue;
    }

    final prevCode = (prev['code'] ?? '').toString().toLowerCase();
    final nextCode = (lesson['code'] ?? '').toString().toLowerCase();
    if (prevCode != nextCode &&
        (nextCode.contains('cancel') || nextCode == 'cancelled')) {
      cancelled++;
      continue;
    }

    final prevRoom = (prev['ro'] ?? '').toString();
    final nextRoom = (lesson['ro'] ?? '').toString();
    if (prevRoom != nextRoom) {
      room++;
      continue;
    }

    final prevTeacher = (prev['te'] ?? '').toString();
    final nextTeacher = (lesson['te'] ?? '').toString();
    if (prevTeacher != nextTeacher) {
      substitution++;
      continue;
    }
  }

  return {
    'cancelled': cancelled,
    'room': room,
    'substitution': substitution,
    'other': other,
  };
}

String _localizedChangeSummary(String locale, Map<String, int> counts) {
  final cancelled = counts['cancelled'] ?? 0;
  final room = counts['room'] ?? 0;
  final substitution = counts['substitution'] ?? 0;
  final other = counts['other'] ?? 0;

  if (locale == 'sk') {
    final parts = <String>[];
    if (cancelled > 0) parts.add('$cancelled zruseni');
    if (room > 0) parts.add('$room zmien miestnosti');
    if (substitution > 0) parts.add('$substitution zastupovani');
    if (other > 0 || parts.isEmpty) {
      parts.add('${other > 0 ? other : 1} aktualizacii');
    }
    return parts.join(' · ');
  }

  final parts = <String>[];
  if (cancelled > 0) parts.add('$cancelled cancellations');
  if (room > 0) parts.add('$room room changes');
  if (substitution > 0) parts.add('$substitution substitutions');
  if (other > 0 || parts.isEmpty) parts.add('${other > 0 ? other : 1} updates');
  return parts.join(' · ');
}

String _localizedUpdateBody(String locale, String latestVersion) {
  switch (locale) {
    case 'sk':
      return 'Verzia $latestVersion je dostupna v GitHub Releases.';
    case 'en':
    default:
      return 'Version $latestVersion is available on GitHub Releases.';
  }
}

Future<void> checkGithubUpdateAndNotify() async {
  final prefs = await SharedPreferences.getInstance();
  final installedVersion = prefs.getString('installedAppVersion') ?? '0.0.0';
  final locale = prefs.getString('appLocale') == 'sk' ? 'sk' : 'en';

  try {
    final resp = await http.get(
      Uri.parse('https://api.github.com/repos/Kpyruy/Unia/releases/latest'),
      headers: const {'Accept': 'application/vnd.github+json'},
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      return;
    }

    final data = jsonDecode(resp.body);
    if (data is! Map<String, dynamic>) {
      return;
    }

    final tag = (data['tag_name'] ?? '').toString().trim();
    final latestVersion = tag.isEmpty
        ? (data['name'] ?? '').toString().trim()
        : tag;
    final hasComparableVersion = RegExp(r'\d').hasMatch(latestVersion);

    final hasUpdate =
        latestVersion.isNotEmpty &&
        (hasComparableVersion
            ? _compareVersionStrings(installedVersion, latestVersion) < 0
            : true);

    if (!hasUpdate) {
      await NotificationService().cancelNotification(kUpdateNotificationId);
      return;
    }

    await NotificationService().showUpdateNotification(
      id: kUpdateNotificationId,
      title: _localizedUpdateTitle(locale),
      body: _localizedUpdateBody(locale, latestVersion),
    );
  } catch (_) {
    // Keep silent in background; no user-facing error notification needed.
  }
}

Future<void> updateScheduleData() async {
  final prefs = await SharedPreferences.getInstance();
  final isManualMode = prefs.getBool('manualMode') ?? false;
  if (!isManualMode) return;
  final locale = prefs.getString('appLocale') == 'sk' ? 'sk' : 'en';

  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  final definitions = await ManualScheduleService.loadDefinitions(prefs);
  final lessons =
      ManualScheduleService.buildWeek(monday, definitions)[now.weekday - 1] ??
      [];

  if (lessons.isEmpty) {
    await NotificationService().cancelNotification(
      kCurrentLessonNotificationId,
    );
    return;
  }

  lessons.sort(
    (a, b) => (a['startTime'] as int).compareTo(b['startTime'] as int),
  );

  final lessonSignature = jsonEncode(
    lessons
        .whereType<Map>()
        .map(
          (lesson) => {
            'startTime': lesson['startTime'],
            'endTime': lesson['endTime'],
            'code': lesson['code'],
            'lstype': lesson['lstype'],
            'su': lesson['su'],
            'ro': lesson['ro'],
            'te': lesson['te'],
            'kl': lesson['kl'],
          },
        )
        .toList(growable: false),
  );

  String currentLessonName = _localizedFreeLabel(locale);
  String nextLessonName = "-";
  String timeRemaining = "";

  final currentTimeInt = now.hour * 100 + now.minute;
  bool foundCurrent = false;

  int? currentProgress;
  int? maxProgress;
  int? endTimeMs;
  String subTextInfo = _localizedStatusCurrentLesson(locale);

  int breakCountFor(List<dynamic> dayLessons) {
    var breaks = 0;
    for (var i = 0; i < dayLessons.length - 1; i++) {
      final currentEnd = dayLessons[i]['endTime'];
      final nextStart = dayLessons[i + 1]['startTime'];
      if (currentEnd is int && nextStart is int && nextStart > currentEnd) {
        breaks++;
      }
    }
    return breaks;
  }

  DateTime untisTimeToDate(int timeStr) {
    final hour = timeStr ~/ 100;
    final minute = timeStr % 100;
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String lessonDisplayName(Map<dynamic, dynamic> lesson) {
    final subjectList = lesson['su'];
    if (subjectList is List && subjectList.isNotEmpty) {
      final first = subjectList.first;
      if (first is Map) {
        final raw =
            first['longName'] ?? first['longname'] ?? first['name'] ?? '';
        final label = raw.toString().trim();
        if (label.isNotEmpty) return label;
      }
    }

    final start = lesson['startTime'];
    final end = lesson['endTime'];
    if (start is int && end is int) {
      final startStr = formatScheduleTime(start.toString());
      final endStr = formatScheduleTime(end.toString());
      return _localizedFallbackLessonName(locale, startStr, endStr);
    }

    return _localizedStatusCurrentLesson(locale);
  }

  for (int i = 0; i < lessons.length; i++) {
    var l = lessons[i];
    int start = l['startTime'] as int;
    int end = l['endTime'] as int;

    final name = lessonDisplayName(l);

    String startStr = formatScheduleTime(start.toString());
    String endStr = formatScheduleTime(end.toString());

    if (!foundCurrent) {
      if (currentTimeInt >= start && currentTimeInt <= end) {
        currentLessonName = name;
        timeRemaining = _localizedUntilTime(locale, endStr);
        foundCurrent = true;
        subTextInfo = _localizedStatusCurrentLesson(locale);

        DateTime startTimeDate = untisTimeToDate(start);
        DateTime endTimeDate = untisTimeToDate(end);

        maxProgress = endTimeDate.difference(startTimeDate).inMinutes;
        currentProgress = now.difference(startTimeDate).inMinutes;
        endTimeMs = endTimeDate.millisecondsSinceEpoch;

        if (i + 1 < lessons.length) {
          var nextL = lessons[i + 1];
          nextLessonName = lessonDisplayName(nextL);
        } else {
          nextLessonName = _localizedClosedLabel(locale);
        }
      } else if (currentTimeInt < start) {
        timeRemaining = _localizedLessonStartsAt(locale, startStr);
        nextLessonName = name;
        foundCurrent = true;
        subTextInfo = _localizedStatusNextLesson(locale);
        endTimeMs = untisTimeToDate(start).millisecondsSinceEpoch;
      }
    }
  }

  final firstLesson = lessons.first;
  final lastLesson = lessons.last;
  final firstStart = formatScheduleTime(
    (firstLesson['startTime'] as int).toString(),
  );
  final lastEnd = formatScheduleTime((lastLesson['endTime'] as int).toString());
  final breakCount = breakCountFor(lessons);

  if (!foundCurrent && currentTimeInt > (lessons.last['endTime'] as int)) {
    currentLessonName = _localizedClosedLabel(locale);
    nextLessonName = "-";
    timeRemaining = "";
    subTextInfo = _localizedStatusNoClasses(locale);
    await NotificationService().cancelNotification(
      kCurrentLessonNotificationId,
    );
    return;
  }

  final isProgressivePushEnabled = prefs.getBool('progressivePush') ?? true;
  final isDailyBriefingEnabled = prefs.getBool('dailyBriefingPush') ?? true;
  final isImportantChangesEnabled =
      prefs.getBool('importantChangesPush') ?? true;
  await NotificationService().init();

  final todayKey = DateFormat('yyyyMMdd').format(now);
  final lastBriefingDate = prefs.getString('lastDailyBriefingDate') ?? '';
  final firstStartInt = firstLesson['startTime'] as int;
  final canSendBriefingNow = currentTimeInt <= firstStartInt && now.hour < 12;

  if (isDailyBriefingEnabled &&
      lastBriefingDate != todayKey &&
      canSendBriefingNow) {
    await NotificationService().showDailyBriefingNotification(
      title: _localizedDailyBriefingTitle(locale),
      body: _localizedDailyBriefingBody(
        locale,
        firstStart: firstStart,
        lastEnd: lastEnd,
        lessonCount: lessons.length,
        breakCount: breakCount,
      ),
      expandedBody: _localizedDailyBriefingExpanded(
        locale,
        firstStart: firstStart,
        lastEnd: lastEnd,
        lessonCount: lessons.length,
        breakCount: breakCount,
        nextLesson: nextLessonName,
      ),
      locale: locale,
      currentLesson: currentLessonName,
      nextLesson: nextLessonName,
    );
    await prefs.setString('lastDailyBriefingDate', todayKey);
  }

  final signatureKey = 'lastLessonSignature_$todayKey';
  final previousSignature = prefs.getString(signatureKey) ?? '';
  final hasMeaningfulChange =
      previousSignature.isNotEmpty && previousSignature != lessonSignature;
  final changeCounts = _detectChangeCounts(
    previousSignature: previousSignature,
    currentSignature: lessonSignature,
  );

  if (isImportantChangesEnabled && hasMeaningfulChange) {
    await NotificationService().showImportantChangeNotification(
      title: _localizedImportantChangesTitle(locale),
      body:
          '${_localizedImportantChangesBody(locale)} (${_localizedChangeSummary(locale, changeCounts)}) · ${_localizedStatusCurrentLesson(locale)}: $currentLessonName',
      locale: locale,
      currentLesson: currentLessonName,
      nextLesson: nextLessonName,
    );
  }
  await prefs.setString(signatureKey, lessonSignature);

  if (isProgressivePushEnabled) {
    await NotificationService().showProgressiveNotification(
      id: kCurrentLessonNotificationId,
      title: currentLessonName,
      body:
          '${timeRemaining.isNotEmpty ? '$timeRemaining  |  ' : ''}${_localizedThen(locale, nextLessonName)}',
      subText: subTextInfo,
      currentProgress: currentProgress,
      maxProgress: maxProgress,
      endTimeMs: endTimeMs,
      locale: locale,
      nextLesson: nextLessonName,
    );
  } else {
    await NotificationService().cancelNotification(
      kCurrentLessonNotificationId,
    );
  }
}
