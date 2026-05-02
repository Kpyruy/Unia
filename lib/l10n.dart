// ─────────────────────────────────────────────────────────────────────────────
// Unia App Localization
// Supported locales: en (English), sk (Slovak)
// ─────────────────────────────────────────────────────────────────────────────

class AppL10n {
  final String locale;
  const AppL10n._(this.locale);

  static const supportedLocales = ['en', 'sk'];

  static AppL10n of(String locale) =>
      AppL10n._(supportedLocales.contains(locale) ? locale : 'en');

  String _t(String key) => _strings[locale]?[key] ?? _strings['en']![key]!;

  // ── Navigation ──────────────────────────────────────────────────────────────
  String get navWeek => _t('navWeek');
  String get navExams => _t('navExams');
  String get navInfo => _t('navInfo');
  String get navMenu => _t('navMenu');

  // ── Manual setup ────────────────────────────────────────────────────────────
  String get manualModeStart => _t('manualModeStart');
  String get manualModeDesc => _t('manualModeDesc');

  // ── Onboarding ─────────────────────────────────────────────────────────────
  String get onboardingWelcomeTitle => _t('onboardingWelcomeTitle');
  String get onboardingChooseLanguageSubtitle =>
      _t('onboardingChooseLanguageSubtitle');
  String get onboardingAppearanceTitle => _t('onboardingAppearanceTitle');
  String get onboardingAppearanceSubtitle => _t('onboardingAppearanceSubtitle');
  String get onboardingThemeSystem => _t('onboardingThemeSystem');
  String get onboardingThemeLight => _t('onboardingThemeLight');
  String get onboardingThemeDark => _t('onboardingThemeDark');
  String get onboardingAnimationsHint => _t('onboardingAnimationsHint');
  String get onboardingManualSetupTitle => _t('onboardingManualSetupTitle');
  String get onboardingManualSetupSubtitle =>
      _t('onboardingManualSetupSubtitle');
  String get onboardingGeminiTitle => _t('onboardingGeminiTitle');
  String get onboardingGeminiSubtitle => _t('onboardingGeminiSubtitle');
  String get onboardingGeminiInfo => _t('onboardingGeminiInfo');
  String get onboardingGeminiGetApiKey => _t('onboardingGeminiGetApiKey');
  String get onboardingSkip => _t('onboardingSkip');
  String get onboardingNext => _t('onboardingNext');
  String get onboardingGeminiEnterKeyOrSkip =>
      _t('onboardingGeminiEnterKeyOrSkip');
  String get onboardingReadyTitle => _t('onboardingReadyTitle');
  String get onboardingReadySubtitle => _t('onboardingReadySubtitle');
  String get onboardingFeatureTimetableTitle =>
      _t('onboardingFeatureTimetableTitle');
  String get onboardingFeatureTimetableDesc =>
      _t('onboardingFeatureTimetableDesc');
  String get onboardingFeatureExamsTitle => _t('onboardingFeatureExamsTitle');
  String get onboardingFeatureExamsDesc => _t('onboardingFeatureExamsDesc');
  String get onboardingFeatureAiTitle => _t('onboardingFeatureAiTitle');
  String get onboardingFeatureAiDesc => _t('onboardingFeatureAiDesc');
  String get onboardingFeatureNotifyTitle => _t('onboardingFeatureNotifyTitle');
  String get onboardingFeatureNotifyDesc => _t('onboardingFeatureNotifyDesc');
  String get onboardingFinishSetup => _t('onboardingFinishSetup');
  String get tutorialTitle => _t('tutorialTitle');
  String get tutorialSkip => _t('tutorialSkip');
  String get tutorialDone => _t('tutorialDone');
  String get tutorialStepWeekTitle => _t('tutorialStepWeekTitle');
  String get tutorialStepWeekDesc => _t('tutorialStepWeekDesc');
  String get tutorialStepExamsTitle => _t('tutorialStepExamsTitle');
  String get tutorialStepExamsDesc => _t('tutorialStepExamsDesc');
  String get tutorialStepInfoTitle => _t('tutorialStepInfoTitle');
  String get tutorialStepInfoDesc => _t('tutorialStepInfoDesc');
  String get tutorialStepSettingsTitle => _t('tutorialStepSettingsTitle');
  String get tutorialStepSettingsDesc => _t('tutorialStepSettingsDesc');
  String get tutorialStepFinishTitle => _t('tutorialStepFinishTitle');
  String get tutorialStepFinishDesc => _t('tutorialStepFinishDesc');

  // ── Timetable ───────────────────────────────────────────────────────────────
  String get timetableTitle => _t('timetableTitle');
  String get timetablePrevWeek => _t('timetablePrevWeek');
  String get timetableNextWeek => _t('timetableNextWeek');
  String get timetableWeekView => _t('timetableWeekView');
  String get timetableDayGrid => _t('timetableDayGrid');
  String get timetableNotLoaded => _t('timetableNotLoaded');
  String get timetableReload => _t('timetableReload');
  String get timetableMyTimetable => _t('timetableMyTimetable');
  List<String> get weekDayShort => List<String>.from(
    (_strings[locale]?['weekDayShort'] ?? _strings['en']!['weekDayShort'])
        as List,
  );
  List<String> get weekDayFull => List<String>.from(
    (_strings[locale]?['weekDayFull'] ?? _strings['en']!['weekDayFull'])
        as List,
  );
  String get noLesson => _t('noLesson');
  String get manualLessonAdd => _t('manualLessonAdd');
  String get manualLessonEdit => _t('manualLessonEdit');
  String get manualLessonSubject => _t('manualLessonSubject');
  String get manualLessonSubjectShort => _t('manualLessonSubjectShort');
  String get manualLessonTeacher => _t('manualLessonTeacher');
  String get manualLessonRoom => _t('manualLessonRoom');
  String get manualLessonDay => _t('manualLessonDay');
  String get manualLessonStart => _t('manualLessonStart');
  String get manualLessonEnd => _t('manualLessonEnd');
  String get manualLessonSave => _t('manualLessonSave');
  String get manualLessonCancel => _t('manualLessonCancel');
  String get manualLessonDelete => _t('manualLessonDelete');

  // ── Lesson Detail ───────────────────────────────────────────────────────────
  String get detailTime => _t('detailTime');
  String get detailTeacher => _t('detailTeacher');
  String get detailRoom => _t('detailRoom');
  String get detailLesson => _t('detailLesson');
  String get detailInfo => _t('detailInfo');
  String get detailCancelled => _t('detailCancelled');
  String get detailRegular => _t('detailRegular');
  String get detailHideSubject => _t('detailHideSubject');
  String get detailCancelledBadge => _t('detailCancelledBadge');

  // ── Exams ───────────────────────────────────────────────────────────────────
  String get examsTitle => _t('examsTitle');
  String get examsReload => _t('examsReload');
  String get examsNone => _t('examsNone');
  String get examsNoneHint => _t('examsNoneHint');
  String get examsUpcoming => _t('examsUpcoming');
  String get examsPast => _t('examsPast');
  String get examsAdd => _t('examsAdd');
  String get examsAddTitle => _t('examsAddTitle');
  String get examsEditTitle => _t('examsEditTitle');
  String get examsSubjectLabel => _t('examsSubjectLabel');
  String get examsTypeLabel => _t('examsTypeLabel');
  String get examsNotesLabel => _t('examsNotesLabel');
  String get examsSave => _t('examsSave');
  String get examsCancel => _t('examsCancel');
  String get examsDelete => _t('examsDelete');
  String get examsToday => _t('examsToday');
  String get examsTomorrow => _t('examsTomorrow');
  String get examsOwn => _t('examsOwn');
  String get examsUnknown => _t('examsUnknown');
  String get examsImportTitle => _t('examsImportTitle');
  String get examsImportCamera => _t('examsImportCamera');
  String get examsImportGallery => _t('examsImportGallery');
  String get examsImportFile => _t('examsImportFile');
  String get examsImportSuccess => _t('examsImportSuccess');
  String get examsImportError => _t('examsImportError');
  String get examsImportInvalidJson => _t('examsImportInvalidJson');
  String get examsExportSuccess => _t('examsExportSuccess');
  String get examsExportEmpty => _t('examsExportEmpty');
  String get examsActionCustom => _t('examsActionCustom');
  String get examsActionImport => _t('examsActionImport');
  String get examsActionExport => _t('examsActionExport');
  String get examsActionScan => _t('examsActionScan');
  String examsInDays(int n) => _t('examsDaysIn').replaceAll('{n}', '$n');

  // ── Info / Notifications ───────────────────────────────────────────────────
  String get infoTitle => _t('infoTitle');
  String get infoReload => _t('infoReload');
  String get infoUpdated => _t('infoUpdated');
  String get infoEmpty => _t('infoEmpty');
  String get infoEmptyHint => _t('infoEmptyHint');
  String get infoFetchError => _t('infoFetchError');
  String get infoOpenLink => _t('infoOpenLink');
  String notificationActionCurrentLesson(String lesson) =>
      _t('notificationActionCurrentLesson').replaceAll('{lesson}', lesson);
  String notificationActionNextLesson(String lesson) =>
      _t('notificationActionNextLesson').replaceAll('{lesson}', lesson);
  String get notificationActionNoNextLesson =>
      _t('notificationActionNoNextLesson');

  // ── AI Chat ─────────────────────────────────────────────────────────────────
  String get aiTitle => _t('aiTitle');
  String get aiInputHint => _t('aiInputHint');
  String get aiKnowsSchedule => _t('aiKnowsSchedule');
  String get aiAskAnything => _t('aiAskAnything');
  String get aiNoApiKey => _t('aiNoApiKey');
  String get aiNoReply => _t('aiNoReply');
  String get aiApiError => _t('aiApiError');
  String get aiConnectionError => _t('aiConnectionError');
  String get aiCustomBaseUrlMissing => _t('aiCustomBaseUrlMissing');
  List<String> get aiSuggestions => List<String>.from(
    (_strings[locale]?['aiSuggestions'] ?? _strings['en']!['aiSuggestions'])
        as List,
  );

  // ── Settings ─────────────────────────────────────────────────────────────────
  String get settingsTitle => _t('settingsTitle');
  String get settingsLoggedInAs => _t('settingsLoggedInAs');
  String get settingsLogout => _t('settingsLogout');
  String get settingsSectionQuick => _t('settingsSectionQuick');
  String get settingsSectionGeneral => _t('settingsSectionGeneral');
  String get settingsAppearance => _t('settingsAppearance');
  String get settingsAppearanceDesc => _t('settingsAppearanceDesc');
  String get settingsLanguage => _t('settingsLanguage');
  String get settingsSectionAI => _t('settingsSectionAI');
  String get settingsAiProvider => _t('settingsAiProvider');
  String get settingsAiProviderGemini => _t('settingsAiProviderGemini');
  String get settingsAiProviderOpenAi => _t('settingsAiProviderOpenAi');
  String get settingsAiProviderMistral => _t('settingsAiProviderMistral');
  String get settingsAiProviderCustom => _t('settingsAiProviderCustom');
  String get settingsAiModel => _t('settingsAiModel');
  String get settingsAiApiKey => _t('settingsAiApiKey');
  String get settingsAiApiKeyNotSet => _t('settingsAiApiKeyNotSet');
  String get settingsAiApiKeyDialogDesc => _t('settingsAiApiKeyDialogDesc');
  String get settingsAiApiKeyGet => _t('settingsAiApiKeyGet');
  String get settingsAiApiKeyOpenFailed => _t('settingsAiApiKeyOpenFailed');
  String get settingsAiPrompt => _t('settingsAiPrompt');
  String get settingsAiPromptDesc => _t('settingsAiPromptDesc');
  String get settingsAiPromptEditTitle => _t('settingsAiPromptEditTitle');
  String get settingsAiPromptReset => _t('settingsAiPromptReset');
  String get settingsAiPromptVariables => _t('settingsAiPromptVariables');
  String get settingsAiPromptVariablesDesc =>
      _t('settingsAiPromptVariablesDesc');
  String get settingsAiCustomBaseUrl => _t('settingsAiCustomBaseUrl');
  String get settingsAiCustomBaseUrlDesc => _t('settingsAiCustomBaseUrlDesc');
  String get settingsAiCustomBaseUrlHint => _t('settingsAiCustomBaseUrlHint');
  String get settingsAiCompatibility => _t('settingsAiCompatibility');
  String get settingsAiCompatibilityOpenAi =>
      _t('settingsAiCompatibilityOpenAi');
  String get settingsAiCompatibilityGemini =>
      _t('settingsAiCompatibilityGemini');
  String get settingsApiKey => _t('settingsApiKey');
  String get settingsApiKeyNotSet => _t('settingsApiKeyNotSet');
  String get settingsApiKeyDialogTitle => _t('settingsApiKeyDialogTitle');
  String get settingsApiKeyDialogDesc => _t('settingsApiKeyDialogDesc');
  String get settingsApiKeySave => _t('settingsApiKeySave');
  String get settingsApiKeyRemove => _t('settingsApiKeyRemove');
  String get settingsApiKeyCancel => _t('settingsApiKeyCancel');
  String get settingsSectionHidden => _t('settingsSectionHidden');
  String get settingsNoHidden => _t('settingsNoHidden');
  String get settingsNoHiddenDesc => _t('settingsNoHiddenDesc');
  String get settingsUnhide => _t('settingsUnhide');
  String settingsHiddenCount(int n) =>
      _t('settingsHiddenCount').replaceAll('{n}', '$n');
  String get settingsSectionColors => _t('settingsSectionColors');
  String get settingsColorsDesc => _t('settingsColorsDesc');
  String get settingsNoSubjectsLoaded => _t('settingsNoSubjectsLoaded');
  String get settingsNoSubjectsLoadedDesc => _t('settingsNoSubjectsLoadedDesc');
  String get settingsCustomColor => _t('settingsCustomColor');
  String get settingsDefaultColor => _t('settingsDefaultColor');
  String settingsColorFor(String s) =>
      _t('settingsColorFor').replaceAll('{s}', s);
  String get settingsColorReset => _t('settingsColorReset');
  String get settingsColorCustomPicker => _t('settingsColorCustomPicker');
  String get settingsColorApply => _t('settingsColorApply');
  String get settingsColorRed => _t('settingsColorRed');
  String get settingsColorGreen => _t('settingsColorGreen');
  String get settingsColorBlue => _t('settingsColorBlue');
  String get settingsThemeMode => _t('settingsThemeMode');
  String get settingsThemeLight => _t('settingsThemeLight');
  String get settingsThemeSystem => _t('settingsThemeSystem');
  String get settingsThemeDark => _t('settingsThemeDark');
  String get settingsSectionTimetable => _t('settingsSectionTimetable');
  String get settingsSectionData => _t('settingsSectionData');
  String get settingsExportStudyData => _t('settingsExportStudyData');
  String get settingsExportStudyDataDesc => _t('settingsExportStudyDataDesc');
  String get settingsImportStudyData => _t('settingsImportStudyData');
  String get settingsImportStudyDataDesc => _t('settingsImportStudyDataDesc');
  String get settingsExportSuccess => _t('settingsExportSuccess');
  String get settingsExportCancelled => _t('settingsExportCancelled');
  String get settingsExportFailed => _t('settingsExportFailed');
  String get settingsImportSuccess => _t('settingsImportSuccess');
  String get settingsImportCancelled => _t('settingsImportCancelled');
  String get settingsImportInvalid => _t('settingsImportInvalid');
  String get settingsImportFailed => _t('settingsImportFailed');
  String get settingsShowCancelled => _t('settingsShowCancelled');
  String get settingsShowCancelledDesc => _t('settingsShowCancelledDesc');
  String get settingsBackgroundAnimations => _t('settingsBackgroundAnimations');
  String get settingsBackgroundAnimationsDesc =>
      _t('settingsBackgroundAnimationsDesc');
  String get settingsBackgroundGyroscope => _t('settingsBackgroundGyroscope');
  String get settingsBackgroundGyroscopeDesc =>
      _t('settingsBackgroundGyroscopeDesc');
  String get settingsBackgroundStyle => _t('settingsBackgroundStyle');
  String get settingsBackgroundStyleOrbs => _t('settingsBackgroundStyleOrbs');
  String get settingsBackgroundStyleSpace => _t('settingsBackgroundStyleSpace');
  String get settingsBackgroundStyleBubbles =>
      _t('settingsBackgroundStyleBubbles');
  String get settingsBackgroundStyleLines => _t('settingsBackgroundStyleLines');
  String get settingsBackgroundStyleThreeD =>
      _t('settingsBackgroundStyleThreeD');
  String get settingsBackgroundStyleNebula =>
      _t('settingsBackgroundStyleNebula');
  String get settingsBackgroundStylePrism => _t('settingsBackgroundStylePrism');
  String get settingsBackgroundStyleWaves => _t('settingsBackgroundStyleWaves');
  String get settingsBackgroundStyleGrid => _t('settingsBackgroundStyleGrid');
  String get settingsBackgroundStyleRings => _t('settingsBackgroundStyleRings');
  String get settingsGlassEffect => _t('settingsGlassEffect');
  String get settingsGlassEffectDesc => _t('settingsGlassEffectDesc');
  String get settingsProgressivePush => _t('settingsProgressivePush');
  String get settingsProgressivePushDesc => _t('settingsProgressivePushDesc');
  String get settingsDailyBriefingPush => _t('settingsDailyBriefingPush');
  String get settingsDailyBriefingPushDesc =>
      _t('settingsDailyBriefingPushDesc');
  String get settingsImportantChangesPush => _t('settingsImportantChangesPush');
  String get settingsImportantChangesPushDesc =>
      _t('settingsImportantChangesPushDesc');
  String get settingsRefreshPushWidgetNow => _t('settingsRefreshPushWidgetNow');
  String get settingsRefreshPushWidgetNowDesc =>
      _t('settingsRefreshPushWidgetNowDesc');
  String get settingsBackgroundLoading => _t('settingsBackgroundLoading');
  String get settingsSectionUpdates => _t('settingsSectionUpdates');
  String get settingsSectionAbout => _t('settingsSectionAbout');
  String get appName => _t('appName');
  String get settingsAppVersion => _t('settingsAppVersion');
  String get settingsBuild => _t('settingsBuild');
  String get settingsSectionSubjects => _t('settingsSectionSubjects');
  String get settingsGithubRepoLabel => _t('settingsGithubRepoLabel');
  String get settingsGithubUpdateCheck => _t('settingsGithubUpdateCheck');
  String get settingsGithubUpdateCheckDesc =>
      _t('settingsGithubUpdateCheckDesc');
  String get settingsGithubDirectDownload => _t('settingsGithubDirectDownload');
  String get settingsGithubDirectDownloadDesc =>
      _t('settingsGithubDirectDownloadDesc');
  String get settingsGithubChecking => _t('settingsGithubChecking');
  String settingsGithubUpdateFound(String v) =>
      _t('settingsGithubUpdateFound').replaceAll('{v}', v);
  String get settingsGithubDownloadNow => _t('settingsGithubDownloadNow');
  String get settingsGithubNoDownloadAsset =>
      _t('settingsGithubNoDownloadAsset');
  String get settingsGithubDownloadStarted =>
      _t('settingsGithubDownloadStarted');
  String get settingsGithubOpenFailed => _t('settingsGithubOpenFailed');
  String get settingsGithubCheckFailed => _t('settingsGithubCheckFailed');
  String get settingsGithubNoUpdate => _t('settingsGithubNoUpdate');
  String get settingsGithubCurrentVersion => _t('settingsGithubCurrentVersion');
  String get settingsGithubLatestVersion => _t('settingsGithubLatestVersion');
  String get settingsGithubInstallQuestion =>
      _t('settingsGithubInstallQuestion');
  String get settingsGithubInstallNow => _t('settingsGithubInstallNow');
  String get settingsGithubInstallLater => _t('settingsGithubInstallLater');
  String get settingsGithubInstallPrompted =>
      _t('settingsGithubInstallPrompted');
  String get settingsGithubOpenReleasePage =>
      _t('settingsGithubOpenReleasePage');

  // ── AI System Prompt ─────────────────────────────────────────────────────────
  String get aiSystemPersona => _t('aiSystemPersona');
  String get aiSystemRules => _t('aiSystemRules');

  // ─────────────────────────────────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _strings = {
    // ── ENGLISH ───────────────────────────────────────────────────────────────
    'en': {
      'navWeek': 'Week',
      'navExams': 'Exams',
      'navInfo': 'Info',
      'navMenu': 'Menu',

      'manualModeStart': 'Start manual timetable',
      'manualModeDesc':
          'Add your lessons and exams yourself. No external account is required.',

      'onboardingWelcomeTitle': 'Welcome to Unia',
      'onboardingChooseLanguageSubtitle': 'Choose your preferred language',
      'onboardingAppearanceTitle': 'Appearance',
      'onboardingAppearanceSubtitle': 'Make Unia look exactly how you want',
      'onboardingThemeSystem': 'System',
      'onboardingThemeLight': 'Light',
      'onboardingThemeDark': 'Dark',
      'onboardingAnimationsHint': 'Enable beautiful background animations',
      'onboardingManualSetupTitle': 'Manual timetable',
      'onboardingManualSetupSubtitle': 'Create your schedule yourself',
      'onboardingGeminiTitle': 'Gemini AI',
      'onboardingGeminiSubtitle': 'Chat with your schedule and homework',
      'onboardingGeminiInfo':
          'Get a free Gemini API key from Google AI Studio to unlock the powerful AI assistant in Unia.',
      'onboardingGeminiGetApiKey': 'Get API Key',
      'onboardingSkip': 'Skip',
      'onboardingNext': 'Next',
      'onboardingGeminiEnterKeyOrSkip': 'Please enter a key or skip this step',
      'onboardingReadyTitle': 'Ready to go!',
      'onboardingReadySubtitle': 'Here is what you can do in Unia',
      'onboardingFeatureTimetableTitle': 'Timetable & Calendar',
      'onboardingFeatureTimetableDesc': 'View your schedule flawlessly.',
      'onboardingFeatureExamsTitle': 'Exams & Homework',
      'onboardingFeatureExamsDesc':
          'Track progress, import exams, and export them as JSON.',
      'onboardingFeatureAiTitle': 'AI Assistant',
      'onboardingFeatureAiDesc':
          'Ask Gemini about your day, homework or exams.',
      'onboardingFeatureNotifyTitle': 'Notifications & Widgets',
      'onboardingFeatureNotifyDesc': 'Stay updated before your day starts.',
      'onboardingFinishSetup': 'Finish Setup',
      'tutorialTitle': 'Quick app tutorial',
      'tutorialSkip': 'Skip tutorial',
      'tutorialDone': 'Finish tutorial',
      'tutorialStepWeekTitle': '1. Timetable',
      'tutorialStepWeekDesc':
          'Tap the large clock button to switch to your weekly timetable.',
      'tutorialStepExamsTitle': '2. Exams',
      'tutorialStepExamsDesc':
          'Tap the exams button to view, import, and export exams.',
      'tutorialStepInfoTitle': '3. Info',
      'tutorialStepInfoDesc':
          'Tap the info button to view your timetable notes.',
      'tutorialStepSettingsTitle': '4. Settings',
      'tutorialStepSettingsDesc':
          'Tap the settings button to customize language, design and notifications.',
      'tutorialStepFinishTitle': 'Done!',
      'tutorialStepFinishDesc':
          'You now know all core sections of the app. Have fun with Unia!',

      'timetableTitle': 'Timetable',
      'timetablePrevWeek': 'Previous week',
      'timetableNextWeek': 'Next week',
      'timetableWeekView': 'Week view',
      'timetableDayGrid': 'Day grid',
      'timetableNotLoaded': 'Timetable not loaded',
      'timetableReload': 'Reload',
      'timetableMyTimetable': 'My timetable',
      'weekDayShort': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      'weekDayFull': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      'noLesson': '(no lessons)',
      'manualLessonAdd': 'Add lesson',
      'manualLessonEdit': 'Edit lesson',
      'manualLessonSubject': 'Subject',
      'manualLessonSubjectShort': 'Short name',
      'manualLessonTeacher': 'Teacher',
      'manualLessonRoom': 'Room',
      'manualLessonDay': 'Day',
      'manualLessonStart': 'Start',
      'manualLessonEnd': 'End',
      'manualLessonSave': 'Save',
      'manualLessonCancel': 'Cancel',
      'manualLessonDelete': 'Delete',

      'detailTime': 'Time',
      'detailTeacher': 'Teacher',
      'detailRoom': 'Room',
      'detailLesson': 'Lesson',
      'detailInfo': 'Note',
      'detailCancelled': 'CANCELLED',
      'detailRegular': 'Regular lesson',
      'detailHideSubject': 'Permanently hide subject',
      'detailCancelledBadge': 'CANCELLED',

      'examsTitle': 'Exams',
      'examsReload': 'Reload',
      'examsNone': 'No exams found',
      'examsNoneHint': 'Tap + to add an exam.',
      'examsUpcoming': 'Upcoming',
      'examsPast': 'Past',
      'examsAdd': '',
      'examsAddTitle': 'Add exam',
      'examsEditTitle': 'Edit exam',
      'examsSubjectLabel': 'Subject / Title *',
      'examsTypeLabel': 'Type (e.g. test, quiz)',
      'examsNotesLabel': 'Notes / Topics',
      'examsSave': 'Save',
      'examsCancel': 'Cancel',
      'examsDelete': 'Delete',
      'examsToday': 'Today',
      'examsTomorrow': 'Tomorrow',
      'examsDaysIn': 'in {n} days',
      'examsOwn': 'Custom',
      'examsUnknown': '(unknown)',
      'examsImportTitle': 'Upload exam schedule',
      'examsImportCamera': 'Camera',
      'examsImportGallery': 'Gallery',
      'examsImportFile': 'PDF / File',
      'examsImportSuccess': 'Successfully imported!',
      'examsImportError': 'Import error: ',
      'examsImportInvalidJson': 'No valid JSON found.',
      'examsExportSuccess': 'Exams copied as JSON to clipboard.',
      'examsExportEmpty': 'No custom exams to export.',
      'examsActionCustom': 'Manual',
      'examsActionImport': 'Import (Scan/PDF)',
      'examsActionExport': 'Export (JSON)',
      'examsActionScan': 'Scan',

      'infoTitle': 'Info',
      'infoReload': 'Reload',
      'infoUpdated': 'Updated',
      'infoEmpty': 'No current notifications',
      'infoEmptyHint': 'Manual mode has no external announcements.',
      'infoFetchError': 'Could not load notifications. Please try again later.',
      'infoOpenLink': 'Open link',
      'notificationActionCurrentLesson': 'Current lesson: {lesson}',
      'notificationActionNextLesson': 'Next lesson: {lesson}',
      'notificationActionNoNextLesson': 'No next lesson found for today',

      'aiTitle': 'AI Assistant',
      'aiInputHint': 'Ask a question…',
      'aiKnowsSchedule': 'I know your timetable!',
      'aiAskAnything': 'Ask me anything about your week.',
      'aiNoApiKey':
          '⚠️ Please enter your API key under Settings → AI Assistant.',
      'aiNoReply': '⚠️ No reply received.',
      'aiApiError': '⚠️ API error:',
      'aiConnectionError': '⚠️ Connection error:',
      'aiCustomBaseUrlMissing':
          '⚠️ Please configure the custom base URL in AI settings first.',
      'aiSuggestions': [
        "What do I have tomorrow?",
        "Do I have a free period today?",
        "When does my day end tomorrow?",
        "Is anything cancelled today?",
      ],

      'settingsTitle': 'Settings',
      'settingsLoggedInAs': 'Profile',
      'settingsLogout': 'Reset setup',
      'settingsSectionQuick': 'Quick Controls',
      'settingsSectionGeneral': 'App',
      'settingsAppearance': 'Appearance',
      'settingsAppearanceDesc': 'System (Light/Dark)',
      'settingsLanguage': 'Language',
      'settingsSectionAI': 'AI Assistant',
      'settingsAiProvider': 'Provider',
      'settingsAiProviderGemini': 'Google Gemini',
      'settingsAiProviderOpenAi': 'OpenAI',
      'settingsAiProviderMistral': 'Mistral AI',
      'settingsAiProviderCustom': 'Custom Provider',
      'settingsAiModel': 'Model',
      'settingsAiApiKey': 'API Key',
      'settingsAiApiKeyNotSet': 'Not configured - tap to set up',
      'settingsAiApiKeyDialogDesc':
          'Required for the AI assistant. Use “Get API Key” to open the correct page for the selected provider.',
      'settingsAiApiKeyGet': 'Get API Key',
      'settingsAiApiKeyOpenFailed': 'Could not open the API key page.',
      'settingsAiPrompt': 'System Prompt',
      'settingsAiPromptDesc':
          'Edit the default prompt and use variables like [timetable].',
      'settingsAiPromptEditTitle': 'Edit system prompt',
      'settingsAiPromptReset': 'Reset to default',
      'settingsAiPromptVariables': 'Prompt Variables',
      'settingsAiPromptVariablesDesc':
          'All placeholders that are automatically replaced with app data.',
      'settingsAiCustomBaseUrl': 'Custom Base URL',
      'settingsAiCustomBaseUrlDesc':
          'Base URL of your own provider (OpenAI-compatible or Gemini-compatible).',
      'settingsAiCustomBaseUrlHint': 'https://api.your-provider.tld/v1',
      'settingsAiCompatibility': 'Custom compatibility',
      'settingsAiCompatibilityOpenAi': 'OpenAI-compatible',
      'settingsAiCompatibilityGemini': 'Gemini-compatible',
      'settingsApiKey': 'Gemini API Key',
      'settingsApiKeyNotSet': 'Not configured — Tap to set up',
      'settingsApiKeyDialogTitle': 'Gemini API Key',
      'settingsApiKeyDialogDesc':
          'Required for the AI assistant. Find your key at aistudio.google.com/app/apikey.',
      'settingsApiKeySave': 'Save',
      'settingsApiKeyRemove': 'Remove',
      'settingsApiKeyCancel': 'Cancel',
      'settingsSectionHidden': 'Hidden Subjects',
      'settingsNoHidden': 'No subjects hidden',
      'settingsNoHiddenDesc': 'Tap a lesson to hide it.',
      'settingsUnhide': 'Show',
      'settingsHiddenCount': '{n} subject(s) hidden',
      'settingsSectionColors': 'Subject Colors',
      'settingsColorsDesc': 'Tap a subject to choose a color.',
      'settingsNoSubjectsLoaded': 'No subjects loaded',
      'settingsNoSubjectsLoadedDesc': 'Open your timetable first.',
      'settingsCustomColor': 'Custom',
      'settingsDefaultColor': 'Default color',
      'settingsColorFor': 'Color for "{s}"',
      'settingsColorReset': 'Reset to default',
      'settingsColorCustomPicker': 'Pick custom color',
      'settingsColorApply': 'Apply color',
      'settingsColorRed': 'Red',
      'settingsColorGreen': 'Green',
      'settingsColorBlue': 'Blue',
      'settingsThemeMode': 'Color scheme',
      'settingsThemeLight': 'Light',
      'settingsThemeSystem': 'System',
      'settingsThemeDark': 'Dark',
      'settingsSectionTimetable': 'Timetable',
      'settingsSectionData': 'Import / Export',
      'settingsExportStudyData': 'Export study data',
      'settingsExportStudyDataDesc':
          'Save timetable, exams, tasks, and setup settings as one JSON file',
      'settingsImportStudyData': 'Import study data',
      'settingsImportStudyDataDesc':
          'Restore timetable, exams, tasks, and setup settings from a JSON file',
      'settingsExportSuccess': 'Study data exported.',
      'settingsExportCancelled': 'Export cancelled.',
      'settingsExportFailed': 'Export failed. Please try again.',
      'settingsImportSuccess': 'Study data imported.',
      'settingsImportCancelled': 'Import cancelled.',
      'settingsImportInvalid': 'Selected file is not a valid Unia backup.',
      'settingsImportFailed': 'Import failed. Please try again.',
      'settingsShowCancelled': 'Show cancelled lessons',
      'settingsShowCancelledDesc':
          'Cancelled lessons are shown in the timetable',
      'settingsBackgroundAnimations': 'Background Animations',
      'settingsBackgroundAnimationsDesc':
          'Show animated gradient effects in the background',
      'settingsBackgroundGyroscope': 'Gyroscope reaction',
      'settingsBackgroundGyroscopeDesc':
          'Lets backgrounds react to device movement',
      'settingsBackgroundStyle': 'Animation Style',
      'settingsBackgroundStyleOrbs': 'Orbs',
      'settingsBackgroundStyleSpace': 'Space',
      'settingsBackgroundStyleBubbles': 'Bubbles',
      'settingsBackgroundStyleLines': 'Lines',
      'settingsBackgroundStyleThreeD': '3D Forms',
      'settingsBackgroundStyleNebula': 'Nebula',
      'settingsBackgroundStylePrism': 'Prism',
      'settingsBackgroundStyleWaves': 'Waves',
      'settingsBackgroundStyleGrid': 'Grid',
      'settingsBackgroundStyleRings': 'Rings',
      'settingsGlassEffect': 'Glass Effect (Blur)',
      'settingsGlassEffectDesc':
          'Enables soft glass/blur effects across the interface',
      'settingsProgressivePush': 'Progressive push notification',
      'settingsProgressivePushDesc':
          'Show the current lesson as a persistent notification',
      'settingsDailyBriefingPush': 'Daily briefing notification',
      'settingsDailyBriefingPushDesc':
          'Shows a compact preview of your day in the morning',
      'settingsImportantChangesPush': 'Important changes',
      'settingsImportantChangesPushDesc':
          'Notifies you about cancellations, room changes, and substitutions',
      'settingsRefreshPushWidgetNow': 'Refresh push & widget now',
      'settingsRefreshPushWidgetNowDesc':
          'Immediately refreshes local timetable data, widgets, and push notifications',
      'settingsBackgroundLoading': 'Data is loading in the background...',
      'settingsSectionUpdates': 'Updates',
      'settingsSectionAbout': 'About',
      'appName': 'Unia',
      'settingsAppVersion': 'Version',
      'settingsBuild': 'Build',
      'settingsSectionSubjects': 'Subjects & Colors',
      'settingsGithubRepoLabel': 'github.com/Kpyruy/Unia',
      'settingsGithubUpdateCheck': 'Check for updates on GitHub',
      'settingsGithubUpdateCheckDesc': 'Checks for a new Unia release.',
      'settingsGithubDirectDownload': 'Download latest version directly',
      'settingsGithubDirectDownloadDesc':
          'When checking, immediately opens the newest APK/release file.',
      'settingsGithubChecking': 'Checking for updates...',
      'settingsGithubUpdateFound': 'New release found: {v}',
      'settingsGithubDownloadNow': 'Download',
      'settingsGithubNoDownloadAsset':
          'No direct download asset found. Opening release page...',
      'settingsGithubDownloadStarted':
          'Download/release has been opened in your browser.',
      'settingsGithubOpenFailed': 'Could not open the download link.',
      'settingsGithubCheckFailed':
          'Update check failed. Please try again later.',
      'settingsGithubNoUpdate': 'You already have the latest version.',
      'settingsGithubCurrentVersion': 'Installed version',
      'settingsGithubLatestVersion': 'Latest version',
      'settingsGithubInstallQuestion':
          'Do you want to download and install this update now?',
      'settingsGithubInstallNow': 'Install now',
      'settingsGithubInstallLater': 'Later',
      'settingsGithubInstallPrompted':
          'Download started. The installation prompt appears after download.',
      'settingsGithubOpenReleasePage': 'Open GitHub release page',

      'aiSystemPersona':
          'You are "Schedule Assistant", a friendly and motivating AI helper for students.',
      'aiSystemRules': '''RULES:
- Answer based on the timetable and exam data above.
- Do NOT invent subjects, times, teachers or other information.
- Consider exams/tests in your answers if applicable.
- If something cannot be derived from the data, say so openly.
- Respect [CANCELLED] markers (those lessons do not take place).
- "Free periods" = gaps between two lessons.
- Answer in English, be helpful, motivating, and concise.
- Do not start automatically with "Yes," – answer directly.
- You may use Markdown for formatting (e.g. lists, **bold**).''',
    },

    // ── SLOVAK ────────────────────────────────────────────────────────────────
    'sk': {
      'navWeek': 'Týždeň',
      'navExams': 'Skúšky',
      'navInfo': 'Info',
      'navMenu': 'Menu',

      'manualModeStart': 'Spustiť manuálny rozvrh',
      'manualModeDesc':
          'Začni bez školského prihlásenia a pridávaj hodiny aj skúšky ručne.',

      'onboardingWelcomeTitle': 'Vitajte v Unia',
      'onboardingChooseLanguageSubtitle': 'Vyberte preferovaný jazyk',
      'onboardingAppearanceTitle': 'Vzhľad',
      'onboardingAppearanceSubtitle': 'Nastavte si Unia podľa seba',
      'onboardingThemeSystem': 'Systém',
      'onboardingThemeLight': 'Svetlý',
      'onboardingThemeDark': 'Tmavý',
      'onboardingAnimationsHint': 'Zapnúť animované pozadie',
      'onboardingManualSetupTitle': 'Manuálny rozvrh',
      'onboardingManualSetupSubtitle': 'Vytvorte si rozvrh sami',
      'onboardingGeminiTitle': 'Gemini AI',
      'onboardingGeminiSubtitle': 'Chatujte so svojím rozvrhom a úlohami',
      'onboardingGeminiInfo':
          'Získajte bezplatný Gemini API kľúč v Google AI Studio a odomknite AI asistenta v Unia.',
      'onboardingGeminiGetApiKey': 'Získať API kľúč',
      'onboardingSkip': 'Preskočiť',
      'onboardingNext': 'Ďalej',
      'onboardingGeminiEnterKeyOrSkip':
          'Zadajte kľúč alebo tento krok preskočte',
      'onboardingReadyTitle': 'Pripravené!',
      'onboardingReadySubtitle': 'Toto môžete robiť v Unia',
      'onboardingFeatureTimetableTitle': 'Rozvrh a kalendár',
      'onboardingFeatureTimetableDesc': 'Majte svoj rozvrh vždy pod kontrolou.',
      'onboardingFeatureExamsTitle': 'Skúšky a úlohy',
      'onboardingFeatureExamsDesc':
          'Sledujte skúšky, importujte ich a exportujte ako JSON.',
      'onboardingFeatureAiTitle': 'AI asistent',
      'onboardingFeatureAiDesc':
          'Pýtajte sa Gemini na svoj deň, úlohy alebo skúšky.',
      'onboardingFeatureNotifyTitle': 'Notifikácie a widgety',
      'onboardingFeatureNotifyDesc':
          'Dostávajte upozornenia pred začiatkom hodín.',
      'onboardingFinishSetup': 'Dokončiť nastavenie',
      'tutorialTitle': 'Krátky návod',
      'tutorialSkip': 'Preskočiť návod',
      'tutorialDone': 'Dokončiť návod',
      'tutorialStepWeekTitle': '1. Rozvrh',
      'tutorialStepWeekDesc':
          'Klepnutím na veľké tlačidlo hodín prepnete na týždenný rozvrh.',
      'tutorialStepExamsTitle': '2. Skúšky',
      'tutorialStepExamsDesc':
          'Klepnutím na tlačidlo skúšok zobrazíte, importujete a exportujete skúšky.',
      'tutorialStepInfoTitle': '3. Info',
      'tutorialStepInfoDesc': 'Klepnutím na info zobrazíte poznámky k rozvrhu.',
      'tutorialStepSettingsTitle': '4. Nastavenia',
      'tutorialStepSettingsDesc':
          'Klepnutím na nastavenia upravíte jazyk, vzhľad a notifikácie.',
      'tutorialStepFinishTitle': 'Hotovo!',
      'tutorialStepFinishDesc':
          'Poznáte hlavné časti aplikácie. Príjemné používanie Unia!',

      'timetableTitle': 'Rozvrh',
      'timetablePrevWeek': 'Predchádzajúci týždeň',
      'timetableNextWeek': 'Ďalší týždeň',
      'timetableWeekView': 'Týždenný pohľad',
      'timetableDayGrid': 'Denná mriežka',
      'timetableNotLoaded': 'Rozvrh nie je načítaný',
      'timetableReload': 'Obnoviť',
      'timetableMyTimetable': 'Môj rozvrh',
      'weekDayShort': ['Po', 'Ut', 'St', 'Št', 'Pi'],
      'weekDayFull': ['Pondelok', 'Utorok', 'Streda', 'Štvrtok', 'Piatok'],
      'noLesson': '(žiadna hodina)',
      'manualLessonAdd': 'Pridať hodinu',
      'manualLessonEdit': 'Upraviť hodinu',
      'manualLessonSubject': 'Predmet',
      'manualLessonSubjectShort': 'Skratka',
      'manualLessonTeacher': 'Učiteľ',
      'manualLessonRoom': 'Miestnosť',
      'manualLessonDay': 'Deň',
      'manualLessonStart': 'Začiatok',
      'manualLessonEnd': 'Koniec',
      'manualLessonSave': 'Uložiť',
      'manualLessonCancel': 'Zrušiť',
      'manualLessonDelete': 'Vymazať',

      'detailTime': 'Čas',
      'detailTeacher': 'Učiteľ',
      'detailRoom': 'Miestnosť',
      'detailLesson': 'Hodina',
      'detailInfo': 'Poznámka',
      'detailCancelled': 'ZRUŠENÉ',
      'detailRegular': 'Bežná hodina',
      'detailHideSubject': 'Trvalo skryť predmet',
      'detailCancelledBadge': 'ZRUŠENÉ',

      'examsTitle': 'Skúšky',
      'examsReload': 'Obnoviť',
      'examsNone': 'Nenašli sa žiadne skúšky',
      'examsNoneHint': 'Klepnutím na + pridáte skúšku.',
      'examsUpcoming': 'Nadchádzajúce',
      'examsPast': 'Minulé',
      'examsAddTitle': 'Pridať skúšku',
      'examsEditTitle': 'Upraviť skúšku',
      'examsSubjectLabel': 'Predmet / názov *',
      'examsTypeLabel': 'Typ (napr. test, písomka)',
      'examsNotesLabel': 'Poznámky / témy',
      'examsSave': 'Uložiť',
      'examsCancel': 'Zrušiť',
      'examsDelete': 'Vymazať',
      'examsToday': 'Dnes',
      'examsTomorrow': 'Zajtra',
      'examsDaysIn': 'o {n} dní',
      'examsOwn': 'Vlastné',
      'examsUnknown': '(neznáme)',
      'examsActionCustom': 'Manuálne',
      'examsActionImport': 'Import (scan/PDF)',
      'examsActionExport': 'Export (JSON)',
      'examsActionScan': 'Skenovať',

      'infoTitle': 'Info',
      'infoReload': 'Obnoviť',
      'infoUpdated': 'Aktualizované',
      'infoEmpty': 'Žiadne aktuálne upozornenia',
      'infoEmptyHint': 'Manuálny režim nemá externé oznamy.',
      'infoFetchError': 'Upozornenia sa nepodarilo načítať.',
      'infoOpenLink': 'Otvoriť odkaz',

      'aiTitle': 'AI asistent',
      'aiInputHint': 'Položte otázku…',
      'aiKnowsSchedule': 'Poznám váš rozvrh!',
      'aiAskAnything': 'Opýtajte sa ma na svoj týždeň.',
      'aiSuggestions': [
        'Čo mám zajtra?',
        'Mám dnes voľnú hodinu?',
        'Kedy zajtra končím?',
        'Je dnes niečo zrušené?',
      ],

      'settingsTitle': 'Nastavenia',
      'settingsLogout': 'Odhlásiť sa',
      'settingsSectionQuick': 'Rýchle ovládanie',
      'settingsSectionGeneral': 'Aplikácia',
      'settingsAppearance': 'Vzhľad',
      'settingsAppearanceDesc': 'Systém (svetlý/tmavý)',
      'settingsLanguage': 'Jazyk',
      'settingsSectionAI': 'AI asistent',
      'settingsAiProvider': 'Poskytovateľ',
      'settingsAiProviderGemini': 'Google Gemini',
      'settingsAiProviderOpenAi': 'OpenAI',
      'settingsAiProviderMistral': 'Mistral AI',
      'settingsAiProviderCustom': 'Vlastný poskytovateľ',
      'settingsAiModel': 'Model',
      'settingsAiApiKey': 'API kľúč',
      'settingsAiApiKeyNotSet': 'Nenastavené - klepnite pre nastavenie',
      'settingsAiApiKeyGet': 'Získať API kľúč',
      'settingsAiPrompt': 'Systémový prompt',
      'settingsAiPromptEditTitle': 'Upraviť systémový prompt',
      'settingsAiPromptReset': 'Obnoviť predvolené',
      'settingsAiPromptVariables': 'Premenné promptu',
      'settingsApiKeySave': 'Uložiť',
      'settingsApiKeyRemove': 'Odstrániť',
      'settingsApiKeyCancel': 'Zrušiť',
      'settingsSectionHidden': 'Skryté predmety',
      'settingsNoHidden': 'Žiadne skryté predmety',
      'settingsUnhide': 'Zobraziť',
      'settingsHiddenCount': '{n} skrytých predmetov',
      'settingsSectionColors': 'Farby predmetov',
      'settingsNoSubjectsLoaded': 'Žiadne predmety nie sú načítané',
      'settingsCustomColor': 'Vlastná',
      'settingsDefaultColor': 'Predvolená farba',
      'settingsColorFor': 'Farba pre "{s}"',
      'settingsColorReset': 'Obnoviť',
      'settingsColorCustomPicker': 'Vybrať vlastnú farbu',
      'settingsColorApply': 'Použiť farbu',
      'settingsColorRed': 'Červená',
      'settingsColorGreen': 'Zelená',
      'settingsColorBlue': 'Modrá',
      'settingsThemeMode': 'Farebná schéma',
      'settingsThemeLight': 'Svetlá',
      'settingsThemeSystem': 'Systém',
      'settingsThemeDark': 'Tmavá',
      'settingsSectionTimetable': 'Rozvrh',
      'settingsSectionData': 'Import / Export',
      'settingsExportStudyData': 'Exportovať študijné dáta',
      'settingsExportStudyDataDesc':
          'Uloží rozvrh, skúšky, úlohy a nastavenia do jedného JSON súboru',
      'settingsImportStudyData': 'Importovať študijné dáta',
      'settingsImportStudyDataDesc':
          'Obnoví rozvrh, skúšky, úlohy a nastavenia z JSON súboru',
      'settingsExportSuccess': 'Študijné dáta boli exportované.',
      'settingsExportCancelled': 'Export bol zrušený.',
      'settingsExportFailed': 'Export zlyhal. Skúste to znova.',
      'settingsImportSuccess': 'Študijné dáta boli importované.',
      'settingsImportCancelled': 'Import bol zrušený.',
      'settingsImportInvalid': 'Vybraný súbor nie je platná záloha Unia.',
      'settingsImportFailed': 'Import zlyhal. Skúste to znova.',
      'settingsShowCancelled': 'Zobraziť zrušené hodiny',
      'settingsShowCancelledDesc': 'Zrušené hodiny sa zobrazia v rozvrhu',
      'settingsBackgroundAnimations': 'Animácie pozadia',
      'settingsBackgroundGyroscope': 'Reakcia na gyroskop',
      'settingsBackgroundStyle': 'Štýl animácie',
      'settingsGlassEffect': 'Sklenený efekt (rozmazanie)',
      'settingsProgressivePush': 'Trvalá notifikácia',
      'settingsDailyBriefingPush': 'Denný prehľad',
      'settingsImportantChangesPush': 'Dôležité zmeny',
      'settingsRefreshPushWidgetNow': 'Obnoviť notifikácie a widget',
      'settingsBackgroundLoading': 'Dáta sa načítavajú na pozadí...',
      'settingsSectionUpdates': 'Aktualizácie',
      'settingsSectionAbout': 'O aplikácii',
      'appName': 'Unia',
      'settingsAppVersion': 'Verzia',
      'settingsBuild': 'Build',
      'settingsSectionSubjects': 'Predmety a farby',
      'settingsGithubRepoLabel': 'github.com/Kpyruy/Unia',
      'settingsGithubUpdateCheck': 'Skontrolovať aktualizácie',
      'settingsGithubUpdateCheckDesc': 'Skontroluje novú verziu Unia.',
      'settingsGithubChecking': 'Kontrolujú sa aktualizácie...',
      'settingsGithubUpdateFound': 'Našla sa nová verzia: {v}',
      'settingsGithubDownloadNow': 'Stiahnuť',
      'settingsGithubOpenFailed': 'Odkaz sa nepodarilo otvoriť.',
      'settingsGithubCheckFailed':
          'Kontrola aktualizácií zlyhala. Skúste to neskôr.',
      'settingsGithubNoUpdate': 'Máte najnovšiu verziu.',
      'settingsGithubCurrentVersion': 'Nainštalovaná verzia',
      'settingsGithubLatestVersion': 'Najnovšia verzia',
      'settingsGithubInstallNow': 'Inštalovať teraz',
      'settingsGithubInstallLater': 'Neskôr',
      'settingsGithubOpenReleasePage': 'Otvoriť stránku vydania',

      'aiSystemPersona':
          'Ste "Asistent rozvrhu", priateľský AI pomocník pre študentov.',
      'aiSystemRules': '''PRAVIDLÁ:
- Odpovedajte podľa rozvrhu a údajov o skúškach vyššie.
- Nevymýšľajte si predmety, časy, učiteľov ani iné údaje.
- Ak sa niečo nedá odvodiť z dát, povedzte to otvorene.
- Rešpektujte značky [ZRUŠENÉ].
- "Voľné hodiny" sú medzery medzi dvoma hodinami.
- Odpovedajte po slovensky, užitočne a stručne.
- Nezačínajte automaticky slovom "Áno," - odpovedajte priamo.
- Môžete používať Markdown.''',
    },
  };
}
