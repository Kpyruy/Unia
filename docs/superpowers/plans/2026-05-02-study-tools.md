# Study Tools Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add embedded homework/tasks, per-day lesson statuses, and odd/even week recurrence for manual timetable lessons.

**Architecture:** Keep the first implementation local-first and independent from AI provider behavior. Extend `ManualScheduleService` for recurrence, add focused services for lesson statuses and study tasks, then wire the existing timetable and lesson detail UI to those services.

**Tech Stack:** Flutter, Dart, SharedPreferences, existing manual timetable model, existing English/Slovak localization map.

---

### Task 1: Odd/Even Manual Lesson Recurrence

**Files:**
- Modify: `lib/services/manual_schedule_service.dart`
- Modify: `lib/main.dart`
- Test: `test/manual_schedule_service_test.dart`

- [ ] Add `ManualLessonRecurrence` with `everyWeek`, `oddWeeks`, and `evenWeeks`.
- [ ] Persist recurrence as `recurrence` in manual lesson JSON, defaulting old data to `everyWeek`.
- [ ] Filter `ManualScheduleService.buildWeek()` using ISO week number parity.
- [ ] Add recurrence controls to the manual lesson editor.
- [ ] Run `flutter test test/manual_schedule_service_test.dart`.

### Task 2: Lesson Status Overrides

**Files:**
- Create: `lib/services/lesson_status_service.dart`
- Modify: `lib/main.dart`
- Test: `test/lesson_status_service_test.dart`

- [ ] Store per-date lesson status overrides in SharedPreferences under `lessonStatusOverrides`.
- [ ] Use a stable key made from `date`, manual id when available, start time, end time, and subject.
- [ ] Support `missed`, `cancelled`, and clear status.
- [ ] Apply overrides when building visible week data and in lesson detail actions.
- [ ] Run `flutter test test/lesson_status_service_test.dart`.

### Task 3: Embedded Study Tasks

**Files:**
- Create: `lib/services/study_task_service.dart`
- Modify: `lib/main.dart`
- Test: `test/study_task_service_test.dart`

- [ ] Store tasks locally in SharedPreferences under `studyTasks`.
- [ ] Support title, subject, due date, notes, priority, and status.
- [ ] Add an embedded tasks section to the info/study surface instead of a new bottom tab.
- [ ] Allow add, edit, mark done, and delete.
- [ ] Run `flutter test test/study_task_service_test.dart`.

### Task 4: Verification

- [ ] Run `flutter analyze`.
- [ ] Run focused service tests.
- [ ] Run `flutter build apk --release` if analysis and tests pass.
