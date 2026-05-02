import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StudyTaskStatus {
  todo('todo'),
  inProgress('in_progress'),
  done('done');

  const StudyTaskStatus(this.storageValue);

  final String storageValue;

  static StudyTaskStatus fromStorage(String? value) {
    for (final status in values) {
      if (status.storageValue == value) return status;
    }
    return StudyTaskStatus.todo;
  }
}

enum StudyTaskPriority {
  low('low'),
  normal('normal'),
  high('high');

  const StudyTaskPriority(this.storageValue);

  final String storageValue;

  static StudyTaskPriority fromStorage(String? value) {
    for (final priority in values) {
      if (priority.storageValue == value) return priority;
    }
    return StudyTaskPriority.normal;
  }
}

class StudyTaskService {
  static const String storageKey = 'studyTasks';

  static Future<List<StudyTask>> loadTasks(SharedPreferences prefs) async {
    final raw = prefs.getStringList(storageKey) ?? const [];
    final tasks = raw
        .map((entry) {
          try {
            final decoded = jsonDecode(entry);
            if (decoded is! Map) return null;
            return StudyTask.fromJson(Map<String, dynamic>.from(decoded));
          } catch (_) {
            return null;
          }
        })
        .whereType<StudyTask>()
        .where(
          (task) => task.id.trim().isNotEmpty && task.title.trim().isNotEmpty,
        )
        .toList();
    tasks.sort(_compareTasks);
    return tasks;
  }

  static Future<void> saveTasks(
    SharedPreferences prefs,
    List<StudyTask> tasks,
  ) async {
    final normalized = [...tasks]..sort(_compareTasks);
    await prefs.setStringList(
      storageKey,
      normalized.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }

  static int compareTasks(StudyTask a, StudyTask b) => _compareTasks(a, b);

  static int _compareTasks(StudyTask a, StudyTask b) {
    final byDone = (a.status == StudyTaskStatus.done ? 1 : 0).compareTo(
      b.status == StudyTaskStatus.done ? 1 : 0,
    );
    if (byDone != 0) return byDone;
    final byDue = a.dueDate.compareTo(b.dueDate);
    if (byDue != 0) return byDue;
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  }
}

class StudyTask {
  final String id;
  final String title;
  final String subject;
  final int dueDate;
  final String notes;
  final StudyTaskPriority priority;
  final StudyTaskStatus status;

  const StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.notes,
    required this.priority,
    required this.status,
  });

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      dueDate: (json['dueDate'] as num?)?.toInt() ?? 0,
      notes: json['notes']?.toString() ?? '',
      priority: StudyTaskPriority.fromStorage(json['priority']?.toString()),
      status: StudyTaskStatus.fromStorage(json['status']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'dueDate': dueDate,
    'notes': notes,
    'priority': priority.storageValue,
    'status': status.storageValue,
  };

  StudyTask copyWith({
    String? id,
    String? title,
    String? subject,
    int? dueDate,
    String? notes,
    StudyTaskPriority? priority,
    StudyTaskStatus? status,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudyTask &&
            id == other.id &&
            title == other.title &&
            subject == other.subject &&
            dueDate == other.dueDate &&
            notes == other.notes &&
            priority == other.priority &&
            status == other.status;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, subject, dueDate, notes, priority, status);
}
