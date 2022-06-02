part of 'task_cubit.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> completedTasks;

  TasksLoaded({required this.tasks, required this.completedTasks});
}

class TaskUpdated extends TaskState {
  final List<Task> updatedTasks;
  final List<Task> completedTasks;

  TaskUpdated({required this.updatedTasks, required this.completedTasks});
}

class SnackBarShown extends TaskState {
  final String taskState;
  final Color color;

  SnackBarShown({required this.taskState, required this.color});
}
