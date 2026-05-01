import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = 'com.kpyruy.unia';
  static const String androidWidgetName = 'UniaWidgetProvider';
  static const String iOSWidgetName = 'UniaWidget';

  static Future<void> updateWidgets({
    required String currentLesson,
    required String nextLesson,
    required String timeRemaining,
    required String dailySchedule,
  }) async {
    await HomeWidget.saveWidgetData<String>('current_lesson', currentLesson);
    await HomeWidget.saveWidgetData<String>('next_lesson', nextLesson);
    await HomeWidget.saveWidgetData<String>('time_remaining', timeRemaining);
    await HomeWidget.saveWidgetData<String>('daily_schedule', dailySchedule);

    await HomeWidget.updateWidget(
      name: 'UniaWidgetCurrentLesson',
      iOSName: iOSWidgetName,
      qualifiedAndroidName: 'com.kpyruy.unia.UniaWidgetCurrentLesson',
    );
    await HomeWidget.updateWidget(
      name: 'UniaWidgetDailySchedule',
      iOSName: iOSWidgetName,
      qualifiedAndroidName: 'com.kpyruy.unia.UniaWidgetDailySchedule',
    );
  }
}
