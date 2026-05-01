part of '../main.dart';

// ── APP VERSION ────────────────────────────────────────────────────────────
String appVersion = '0.0.0';
String appBuildNumber = '0';

String profileName = "";
int personId = 0;
int personType = 0;
String geminiApiKey = "";
String openAiApiKey = "";
String mistralApiKey = "";
String customAiApiKey = "";

String aiProvider = 'gemini';
String aiModel = 'gemini-2.5-flash';
String aiSystemPromptTemplate = '';
String aiCustomBaseUrl = '';
String aiCustomCompatibility = 'openai';

const List<String> kSupportedAiProviders = [
  'gemini',
  'openai',
  'mistral',
  'custom',
];

const List<String> kSupportedAiCustomCompatibilities = ['openai', 'gemini'];

String _normalizeAiProvider(String value) {
  return kSupportedAiProviders.contains(value) ? value : 'gemini';
}

String _normalizeAiCustomCompatibility(String value) {
  return kSupportedAiCustomCompatibilities.contains(value) ? value : 'openai';
}

List<String> _modelsForProvider(
  String provider, {
  String? customCompatibility,
}) {
  switch (_normalizeAiProvider(provider)) {
    case 'openai':
      return const ['gpt-4o-mini', 'gpt-4o', 'o4-mini', 'o3-mini'];
    case 'mistral':
      return const [
        'mistral-small-latest',
        'mistral-medium-latest',
        'ministral-8b-latest',
      ];
    case 'custom':
      if (_normalizeAiCustomCompatibility(customCompatibility ?? 'openai') ==
          'gemini') {
        return const ['gemini-2.5-flash', 'gemini-2.5-pro', 'gemini-2.0-flash'];
      }
      return const ['gpt-4o-mini', 'gpt-4o', 'mistral-small-latest'];
    case 'gemini':
    default:
      return const ['gemini-2.5-flash', 'gemini-2.5-pro', 'gemini-2.0-flash'];
  }
}

String _defaultModelForProvider(
  String provider, {
  String? customCompatibility,
}) {
  return _modelsForProvider(
    provider,
    customCompatibility: customCompatibility,
  ).first;
}

String _activeAiApiKey() {
  switch (_normalizeAiProvider(aiProvider)) {
    case 'openai':
      return openAiApiKey;
    case 'mistral':
      return mistralApiKey;
    case 'custom':
      return customAiApiKey;
    case 'gemini':
    default:
      return geminiApiKey;
  }
}

String _localizedAiProviderLabel(AppL10n l, String provider) {
  switch (_normalizeAiProvider(provider)) {
    case 'openai':
      return l.settingsAiProviderOpenAi;
    case 'mistral':
      return l.settingsAiProviderMistral;
    case 'custom':
      return l.settingsAiProviderCustom;
    case 'gemini':
    default:
      return l.settingsAiProviderGemini;
  }
}

String _providerAwareMissingApiKeyMessage(AppL10n l, String provider) {
  return '${l.aiNoApiKey} (${_localizedAiProviderLabel(l, provider)})';
}

const Map<String, String> aiPromptVariableDescriptions = {
  '[today]': 'Current date in the selected locale',
  '[today_iso]': 'Current date in YYYY-MM-DD format',
  '[locale]': 'Active app language (en or sk)',
  '[profile_name]': 'Local timetable profile name',
  '[manual_mode]': 'true when manual timetable mode is active',
  '[current_monday]': 'Monday of the loaded week (DD.MM.YYYY)',
  '[current_friday]': 'Friday of the loaded week (DD.MM.YYYY)',
  '[day_summary_today]': 'Short summary for today',
  '[day_summary_tomorrow]': 'Short summary for tomorrow',
  '[timetable]': 'Formatted timetable for the current week',
  '[timetable_json]': 'Raw timetable data as JSON',
  '[exams]': 'Formatted list of planned exams',
  '[exams_json]': 'Exam data as JSON',
};

final ValueNotifier<String> appLocaleNotifier = ValueNotifier('en');
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.system,
);
final ValueNotifier<bool> showCancelledNotifier = ValueNotifier(true);
final ValueNotifier<bool> backgroundAnimationsNotifier = ValueNotifier(true);
final ValueNotifier<int> backgroundAnimationStyleNotifier = ValueNotifier(0);
final ValueNotifier<bool> backgroundGyroscopeNotifier = ValueNotifier(false);
final ValueNotifier<bool> progressivePushNotifier = ValueNotifier(true);
final ValueNotifier<bool> dailyBriefingPushNotifier = ValueNotifier(true);
final ValueNotifier<bool> importantChangesPushNotifier = ValueNotifier(true);
final ValueNotifier<String?> pendingTimetableActionNotifier = ValueNotifier(
  null,
);
final ValueNotifier<String?> pendingTimetableCurrentLessonNotifier =
    ValueNotifier(null);
final ValueNotifier<String?> pendingTimetableNextLessonNotifier = ValueNotifier(
  null,
);
final ValueNotifier<bool> blurEnabledNotifier = ValueNotifier(true);
final ValueNotifier<bool> manualModeNotifier = ValueNotifier(false);

String _icuLocale(String locale) {
  switch (locale) {
    case 'sk':
      return 'sk_SK';
    case 'en':
    default:
      return 'en_US';
  }
}

final ValueNotifier<Set<String>> hiddenSubjectsNotifier = ValueNotifier({});

Future<void> _hideSubject(String key) async {
  if (key.isEmpty) return;
  final updated = Set<String>.from(hiddenSubjectsNotifier.value)..add(key);
  hiddenSubjectsNotifier.value = updated;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('hiddenSubjects', updated.toList());
}

Future<void> _unhideSubject(String key) async {
  final updated = Set<String>.from(hiddenSubjectsNotifier.value)..remove(key);
  hiddenSubjectsNotifier.value = updated;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('hiddenSubjects', updated.toList());
}

final ValueNotifier<Map<String, int>> subjectColorsNotifier = ValueNotifier({});

final ValueNotifier<Set<String>> knownSubjectsNotifier = ValueNotifier({});

Future<void> _setSubjectColor(String key, int colorValue) async {
  if (key.isEmpty) return;
  final updated = Map<String, int>.from(subjectColorsNotifier.value)
    ..[key] = colorValue;
  subjectColorsNotifier.value = updated;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'subjectColors',
    jsonEncode(Map<String, dynamic>.from(updated)),
  );
}

Future<void> _clearSubjectColor(String key) async {
  final updated = Map<String, int>.from(subjectColorsNotifier.value)
    ..remove(key);
  subjectColorsNotifier.value = updated;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'subjectColors',
    jsonEncode(Map<String, dynamic>.from(updated)),
  );
}

String _formatScheduleTime(String time) {
  return formatScheduleTime(time);
}
