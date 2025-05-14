import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/task_model.dart';
import '../../../providers/task_provider.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  bool isFormValid = true; // Initially valid since we're editing an existing task

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    
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
      title: const Text('Edit Task'),
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
        ElevatedButton(
          onPressed: isFormValid
              ? () {
                  final updatedTask = widget.task.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                  );
                  Provider.of<TaskProvider>(context, listen: false)
                      .updateTask(updatedTask);
                  Navigator.pop(context);
                }
              : null, // Disable button if form is not valid
          style: ElevatedButton.styleFrom(
            // Button will be greyed out when disabled
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade600,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}