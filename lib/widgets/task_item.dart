import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'task-${task.id}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child:ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
            subtitle: task.description.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDate(task.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                  color: Colors.blue.shade300,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.red.shade300,
                ),
              ],
            ),
            onTap: () => _showTaskDetails(context),
          ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) {
                    onToggle();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (task.description.isNotEmpty) ...[
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Created: ${_formatDate(task.createdAt)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}