import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/home/widgets/add_dialog.dart';
import 'package:flutter_todo_app/screens/home/widgets/edit_dialog.dart';
import 'package:flutter_todo_app/utils/drawer_utils.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_progress_bar.dart';
import 'widgets/task_list.dart';
import 'widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isAddingTask = false;
  double _progressValue = 0.0;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {
        _progressValue = _progressAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onTaskAdded: _addTask,
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );
  }

  Future<void> _addTask(String title, String description) async {
    setState(() {
      _isAddingTask = true;
    });

    // Start progress animation
    _animationController.reset();
    _animationController.forward();

    final task = Task(
      title: title,
      description: description,
    );

    await Provider.of<TaskProvider>(context, listen: false).addTask(task);

    setState(() {
      _isAddingTask = false;
    });
  }
  Future<void> _handleTaskDelete(Task task) async {
    final shouldDelete = await showTaskDeleteConfirmationDialog(context);
    if (shouldDelete ?? false) {
      await Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
    }
  }
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.setThemeMode(
                themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
      onRefresh: () async {
        await taskProvider.refreshTasks();
      },
      child:  Column(
        children: [
          if (_isAddingTask)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomProgressBar(
                value: _progressValue,
                height: 8,
              ),
            ),
          HomeSearchBar(
            controller: _searchController,
            onSearchChanged: taskProvider.searchTasks,
            onClearSearch: () {
              _searchController.clear();
              taskProvider.searchTasks('');
            },
          ),
          Expanded(
            child: TaskList(
              tasks: taskProvider.tasks,
              isLoading: taskProvider.isLoading,
              hasMoreData: taskProvider.hasMoreData,
              searchQuery: taskProvider.searchQuery,
              onRefresh: taskProvider.refreshTasks,
              onLoadMore: taskProvider.loadMoreTasks,
              onToggle: taskProvider.toggleTaskCompletion,
              onDelete: _handleTaskDelete,
              onEdit: _showEditTaskDialog,
            ),
          ),
        ],
      ),
      ),floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}