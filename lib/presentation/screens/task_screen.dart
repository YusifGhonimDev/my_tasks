import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tasks/business_logic/task_cubit/task_cubit.dart';
import 'package:my_tasks/helper/notification_helper.dart';
import 'package:my_tasks/presentation/widgets/task_list.dart';
import 'package:my_tasks/presentation/widgets/task_text.dart';

import '../widgets/task_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    context.read<TaskCubit>().getTasks();
    NotificationHelper.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => TaskDialog(actionText: 'Add')),
      ),
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MyTasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      if (state is TasksLoaded) {
                        return TaskText(
                            tasks: state.tasks,
                            completedTasks: state.completedTasks);
                      } else if (state is TaskUpdated) {
                        return TaskText(
                          tasks: state.updatedTasks,
                          completedTasks: state.completedTasks,
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: BlocConsumer<TaskCubit, TaskState>(
                  listener: (context, state) {
                    if (state is SnackBarShown) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Task ${state.taskState}',
                          ),
                          backgroundColor: state.color,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is TasksLoaded) {
                      return TaskList(tasks: state.tasks);
                    } else if (state is TaskUpdated) {
                      return TaskList(tasks: state.updatedTasks);
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
