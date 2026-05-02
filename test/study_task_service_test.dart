import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unia/services/study_task_service.dart';

void main() {
  test(
    'saveTasks round trips tasks sorted by completion and due date',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const later = StudyTask(
        id: 'later',
        title: 'Project',
        subject: 'Programming',
        dueDate: 20260520,
        notes: 'Finish prototype',
        priority: StudyTaskPriority.high,
        status: StudyTaskStatus.todo,
      );
      const done = StudyTask(
        id: 'done',
        title: 'Read chapter',
        subject: 'Math',
        dueDate: 20260510,
        notes: '',
        priority: StudyTaskPriority.normal,
        status: StudyTaskStatus.done,
      );

      await StudyTaskService.saveTasks(prefs, [done, later]);
      final loaded = await StudyTaskService.loadTasks(prefs);

      expect(loaded, [later, done]);
    },
  );

  test('copyWith can mark a task done', () {
    const task = StudyTask(
      id: 'homework',
      title: 'Homework',
      subject: 'Physics',
      dueDate: 20260504,
      notes: '',
      priority: StudyTaskPriority.normal,
      status: StudyTaskStatus.todo,
    );

    expect(
      task.copyWith(status: StudyTaskStatus.done).status,
      StudyTaskStatus.done,
    );
  });
}
