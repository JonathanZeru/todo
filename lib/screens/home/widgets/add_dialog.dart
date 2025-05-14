import 'package:flutter/material.dart';
import 'package:flutter_todo_app/widgets/custom_button.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, String) onTaskAdded;

  const AddTaskDialog({
    Key? key,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    titleController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    titleController.removeListener(_updateFormValidity);
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final valid = titleController.text.trim().isNotEmpty;
    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter task title',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter task description (optional)',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: 'Add',
         onPressed: isFormValid
              ? () {
                  widget.onTaskAdded(
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              : null),
       
      ],
    );
  }
}