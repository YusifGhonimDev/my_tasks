import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/data/model/notification.dart' as n;
import 'package:my_tasks/data/model/task.dart';

import '../../helper/db_helper.dart';
import '../../helper/notification_helper.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];
  TaskCubit() : super(TaskInitial());

  Future<void> getTasks() async {
    NotificationHelper.init();
    await DBHelper.initDB();
    DBHelper.readData().then((tasks) {
      _tasks = tasks;
      _completedTasks = _tasks.where((task) => task.isDone).toList();
      emit(TasksLoaded(tasks: _tasks, completedTasks: _completedTasks));
    });
  }

  void toggleTask(Task task) {
    task.isDone ? _completedTasks.add(task) : _completedTasks.remove(task);
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }

  void addTask(Task task, DateTime deadline) async {
    int taskID = await DBHelper.insertData(
        Task(name: task.name, deadline: task.deadline));
    _tasks.add(
      Task(
        name: task.name,
        deadline: task.deadline,
        id: taskID,
      ),
    );
    _showNotification(
        deadline, Task(name: task.name, deadline: task.deadline, id: taskID));
    emit(SnackBarShown(taskState: 'Added', color: Colors.purple));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }

  void _showNotification(DateTime deadline, Task task) {
    String deadlineString = _getNotificationTime(deadline);
    NotificationHelper.showNotification(n.Notification(
        id: 0,
        title: 'Hey!',
        body: 'Time To ${task.name} At $deadlineString',
        payload: 'payload',
        scheduleTime: deadline.subtract(const Duration(hours: 1))));
  }

  String _getNotificationTime(DateTime deadline) {
    String deadlineHour = deadline.hour.toString().padLeft(2, '0');
    String deadlineMinute = deadline.minute.toString().padLeft(2, '0');
    String deadlineString = int.parse(deadlineHour) > 12
        ? '${int.parse(deadlineHour) - 12}:$deadlineMinute PM'
        : '$deadlineHour:$deadlineMinute AM';
    return deadlineString;
  }

  void deleteTask(int index, int id) {
    _tasks.removeAt(index);
    _completedTasks.removeWhere((task) => task.id == id);
    DBHelper.deleteData(id);
    emit(SnackBarShown(taskState: 'Deleted', color: Colors.red));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }

  void editTask(int index, Task task, DateTime deadline) {
    _tasks[index].name = task.name;
    _tasks[index].deadline = task.deadline;
    DBHelper.updateData(_tasks[index]);
    _showNotification(deadline, task);
    emit(SnackBarShown(taskState: 'Edited', color: Colors.green));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }
}
