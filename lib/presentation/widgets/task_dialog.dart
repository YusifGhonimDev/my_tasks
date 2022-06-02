import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tasks/business_logic/task_cubit/task_cubit.dart';
import 'package:my_tasks/data/model/task.dart';

class TaskDialog extends StatefulWidget {
  final String actionText;
  final int? index;

  const TaskDialog({Key? key, required this.actionText, this.index})
      : super(key: key);

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  DateTime? deadline;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDeadlineController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            title: Text(
              '${widget.actionText} Task',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.purple,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    hintText: 'Enter Task Name',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple)),
                  ),
                  controller: _taskNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Task name cannot be empty' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Task deadline cannot be empty' : null,
                  cursorColor: Colors.purple,
                  controller: _taskDeadlineController,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    TimeOfDay? selectedTime = await showTimePicker(
                      builder: (context, child) {
                        return Theme(
                          child: child!,
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.purple,
                            ),
                          ),
                        );
                      },
                      context: context,
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                      confirmText: "CONFIRM",
                      cancelText: "CANCEL",
                      helpText: "DEADLINE",
                    );
                    if (selectedTime != null) {
                      DateTime deadline = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      this.deadline = deadline;
                      String selectedHour =
                          deadline.hour.toString().padLeft(2, '0');
                      String selectedMinute =
                          deadline.minute.toString().padLeft(2, '0');
                      _taskDeadlineController.clear();
                      _taskDeadlineController.text = selectedTime.hour > 12
                          ? '${int.parse(selectedHour) - 12}:$selectedMinute PM'
                          : '$selectedHour:$selectedMinute AM';
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter Task Deadline',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple)),
                  ),
                ),
                const SizedBox(height: 12),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.actionText == 'Add'
                          ? context.read<TaskCubit>().addTask(
                                Task(
                                  name: _taskNameController.text,
                                  deadline: _taskDeadlineController.text,
                                ),
                                deadline!,
                              )
                          : context.read<TaskCubit>().editTask(
                              widget.index!,
                              Task(
                                  name: _taskNameController.text,
                                  deadline: _taskDeadlineController.text),
                              deadline!);
                      _taskNameController.clear();
                      Navigator.pop(context, _taskNameController.text);
                    }
                  },
                  color: Colors.purple,
                  child: Text(
                    widget.actionText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
