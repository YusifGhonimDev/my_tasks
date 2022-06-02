import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tasks/business_logic/task_cubit/task_cubit.dart';

class TaskDialog extends StatelessWidget {
  final String actionText;
  final int? index;
  final TextEditingController _taskNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TaskDialog({Key? key, required this.actionText, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        title: Text(
          '$actionText Task',
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
              validator: (task) =>
                  task!.isEmpty ? 'Task cannot be empty' : null,
            ),
            const SizedBox(height: 12),
            TextField(
              onTap: () async {
                FocusScope.of(context).unfocus();
                TimeOfDay? selectedDate = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.input,
                  confirmText: "CONFIRM",
                  cancelText: "CANCEL",
                  helpText: "DEADLINE",
                );
                if (selectedDate != null) {
                  // TODO : Add logic to update the deadline
                  // DateTime deadline = DateTime(
                  //   DateTime.now().year,
                  //   DateTime.now().month,
                  //   DateTime.now().day,
                  //   selectedDate.hour,
                  //   selectedDate.minute,
                  // );
                  // print(
                  //     '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}');
                }
              },
              decoration: const InputDecoration(
                hintText: 'Enter Task Deadline',
              ),
            ),
            const SizedBox(height: 12),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  actionText == 'Add'
                      ? context
                          .read<TaskCubit>()
                          .addTask(_taskNameController.text)
                      : context
                          .read<TaskCubit>()
                          .editTask(index!, _taskNameController.text);
                  _taskNameController.clear();
                  Navigator.pop(context, _taskNameController.text);
                }
              },
              color: Colors.purple,
              child: Text(
                actionText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
