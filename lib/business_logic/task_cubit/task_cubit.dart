import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/data/model/task.dart';

import '../../helper/db_helper.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];
  TaskCubit() : super(TaskInitial());

  Future<void> getTasks() async {
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

  void addTask(String taskName) async {
    int taskID = await DBHelper.insertData(Task(name: taskName));
    _tasks.add(
      Task(
        name: taskName,
        id: taskID,
      ),
    );
    emit(SnackBarShown(taskState: 'Added', color: Colors.purple));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }

  void deleteTask(int index, int id) {
    _tasks.removeAt(index);
    DBHelper.deleteData(id);
    emit(SnackBarShown(taskState: 'Deleted', color: Colors.red));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }

  void editTask(int index, String taskName) {
    _tasks[index].name = taskName;
    DBHelper.updateData(_tasks[index]);
    emit(SnackBarShown(taskState: 'Edited', color: Colors.green));
    emit(TaskUpdated(updatedTasks: _tasks, completedTasks: _completedTasks));
  }
}
