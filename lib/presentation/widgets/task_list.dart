import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_tasks/data/model/task.dart';

import '../../business_logic/task_cubit/task_cubit.dart';
import '../../helper/db_helper.dart';
import 'task_dialog.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return widget.tasks.isEmpty
        ? const SizedBox(
            width: double.infinity,
            child: Center(
                child: Text(
              'No Tasks Yet :(',
              style: TextStyle(fontSize: 16),
            )))
        : ListView.builder(
            itemCount: widget.tasks.length,
            itemBuilder: (context, index) {
              Task task = widget.tasks[index];
              return Slidable(
                key: Key(task.name),
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => showDialog(
                        context: context,
                        builder: (context) => TaskDialog(
                          actionText: 'Edit',
                          index: index,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  dismissible: DismissiblePane(
                    onDismissed: () =>
                        context.read<TaskCubit>().deleteTask(index, task.id!),
                  ),
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) =>
                          context.read<TaskCubit>().deleteTask(index, task.id!),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 12,
                  ),
                  title: Text(
                    task.name,
                    style: TextStyle(
                        fontSize: 16,
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null),
                  ),
                  subtitle: Text(
                    task.deadline,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  trailing: Checkbox(
                      activeColor: Colors.purple,
                      value: task.isDone,
                      onChanged: (value) {
                        setState(() {
                          task.isDone = value!;
                          DBHelper.updateData(task);
                          context.read<TaskCubit>().toggleTask(task);
                        });
                      }),
                ),
              );
            });
  }
}
