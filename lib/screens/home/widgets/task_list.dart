import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../../../widgets/task_item.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final bool isLoading;
  final bool hasMoreData;
  final String searchQuery;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore; // Changed to Future<void>
  final Function(Task) onToggle;
  final Function(Task) onDelete;
  final Function(Task) onEdit;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.isLoading,
    required this.hasMoreData,
    required this.searchQuery,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false; // Track if we're currently loading more items

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // This method prevents multiple simultaneous load more calls
  Future<void> _scrollListener() async {

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        widget.hasMoreData &&
        !widget.isLoading) {
      
      setState(() {
        _isLoadingMore = true;
      });
      
      try {
        // Wait for the load more operation to complete
        await widget.onLoadMore();
      } finally {
        // Always reset the loading flag when done, even if there was an error
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator when initially loading with no tasks
    if (widget.isLoading && widget.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state when no tasks are available
    if (widget.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isNotEmpty
                  ? 'No tasks found for "${widget.searchQuery}"'
                  : 'No tasks yet. Add your first task!',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Ensure we reset the loading more state when refreshing
        setState(() {
          _isLoadingMore = false;
        });
        
        // Call the refresh function and await its completion
        await widget.onRefresh();
        
        // Return a completed future to satisfy the RefreshIndicator
        return Future.value();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: widget.tasks.length + (widget.hasMoreData && _isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more items
          if (index == widget.tasks.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            );
          }

          // Otherwise, show the task item
          final task = widget.tasks[index];
          return TaskItem(
            task: task,
            onToggle: () => widget.onToggle(task),
            onDelete: () => widget.onDelete(task),
            onEdit: () => widget.onEdit(task),
          );
        },
      ),
    );
  }
}