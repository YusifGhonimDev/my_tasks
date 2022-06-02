import 'package:flutter/material.dart';
import 'package:my_tasks/data/model/task.dart';

class TaskText extends StatelessWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;

  const TaskText({Key? key, required this.tasks, required this.completedTasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int completedTaskCount = completedTasks.length;
    int inCompletedTaskCount = tasks.length - completedTaskCount;
    inCompletedTaskCount < 0 ? inCompletedTaskCount = 0 : null;
    String task = inCompletedTaskCount <= 1 ? 'Task' : 'Tasks';
    return Text(
      'You Have ${inCompletedTaskCount == 0 ? 'No' : inCompletedTaskCount} $task',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w200,
      ),
    );
  }
}
