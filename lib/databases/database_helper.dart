import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        dueDate TEXT
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks({
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    String query = 'SELECT * FROM tasks';
    List<dynamic> arguments = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query += ' WHERE title LIKE ? OR description LIKE ?';
      arguments.add('%$searchQuery%');
      arguments.add('%$searchQuery%');
    }

    query += ' ORDER BY createdAt DESC';

    if (limit != null) {
      query += ' LIMIT ?';
      arguments.add(limit);

      if (offset != null) {
        query += ' OFFSET ?';
        arguments.add(offset);
      }
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, arguments);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTaskCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM tasks');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}