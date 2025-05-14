import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/task_model.dart';
import '../databases/database_helper.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final Logger _logger = Logger();

  List<Task> _tasks = [];
  String _searchQuery = '';
  bool _isLoading = false;
  int _page = 0;
  final int _limit = 20;
  bool _hasMoreData = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  String get searchQuery => _searchQuery;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks({bool refresh = false}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (refresh) {
        _page = 0;
        _tasks = [];
        _hasMoreData = true;
      }

      final newTasks = await _databaseHelper.getTasks(
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        limit: _limit,
        offset: _page * _limit,
      );

      if (newTasks.isEmpty) {
        _hasMoreData = false;
      } else {
        _tasks.addAll(newTasks);
        _page++;
      }

      _logger.i('Loaded ${newTasks.length} tasks. Total: ${_tasks.length}');
    } catch (e) {
      _logger.e('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


Future<void> loadMoreTasks() async {
  if (_isLoading || !_hasMoreData) return;
  
  try {
    _isLoading = true;
    notifyListeners();

    final newTasks = await _databaseHelper.getTasks(
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      limit: _limit,
      offset: _page * _limit,
    );

    if (newTasks.isEmpty) {
      _hasMoreData = false;
    } else {
      _tasks.addAll(newTasks);
      _page++;
    }

    _logger.i('Loaded ${newTasks.length} tasks. Total: ${_tasks.length}');
  } catch (e) {
    _logger.e('Error loading tasks: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> refreshTasks() async {
  try {
    _isLoading = true;
    notifyListeners();

    _page = 0;
    _tasks = [];
    _hasMoreData = true;

    final newTasks = await _databaseHelper.getTasks(
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      limit: _limit,
      offset: 0,
    );

    if (newTasks.isEmpty) {
      _hasMoreData = false;
    } else {
      _tasks.addAll(newTasks);
      _page++;
    }

    _logger.i('Refreshed tasks. Total: ${_tasks.length}');
  } catch (e) {
    _logger.e('Error refreshing tasks: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
 

  Future<void> addTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();

      final id = await _databaseHelper.insertTask(task);
      final newTask = task.copyWith(id: id);

      _tasks.insert(0, newTask);
      _logger.i('Added new task: ${task.title}');
    } catch (e) {
      _logger.e('Error adding task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _databaseHelper.updateTask(task);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }

      _logger.i('Updated task: ${task.title}');
    } catch (e) {
      _logger.e('Error updating task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _databaseHelper.deleteTask(task.id!);

      _tasks.removeWhere((t) => t.id == task.id);
      _logger.i('Deleted task: ${task.title}');
    } catch (e) {
      _logger.e('Error deleting task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTasks(String query) async {
    _searchQuery = query;
    await refreshTasks();
  }
}