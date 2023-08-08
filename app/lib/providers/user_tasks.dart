import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:app/models/task.dart';

Future<Database> _getDatabase() async{
  final dbPath=await sql.getDatabasesPath();
  final db=await sql.openDatabase(path.join(dbPath, 'tasks.db'), onCreate: (db, version){
    return db.execute('CREATE TABLE user_tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT NOT NULL, status INTEGER DEFAULT 1, completed INTEGER DEFAULT 0, updatedDate DATETIME NOT NULL)');
  }, version: 1);
  return db;
}

class UserTasksNotifier extends StateNotifier<List<Task>>{
  UserTasksNotifier():super(const []);
  
  void loadTasks() async{
      final db=await _getDatabase();
      final data=await db.query('user_tasks', where: 'status=? AND completed=?', whereArgs: [1, 0], orderBy: "updatedDate DESC");
      await db.close();
      final tasks=data.map((row) => Task(
        id: row['id'] as int,
        task: row['task'] as String,
        updatedDate: row['updatedDate'] as String
      )).toList();
      state=tasks;
  }
  
  void addTask(Task newTask) async{
    final db=await _getDatabase();
    var id=await db.insert('user_tasks', {
      'task': newTask.task,
      'updatedDate': newTask.updatedDate
    });
    await db.close();
    state=[Task(id: id, updatedDate: newTask.updatedDate, task: newTask.task), ...state];
  }

  void updateTask(Task newTask) async{
    final db=await _getDatabase();
    await db.update(('user_tasks'), {
      'task': newTask.task,
      'updatedDate': newTask.updatedDate,
    }, where: 'id=?', whereArgs: [newTask.id]);
    await db.close();
    state=state.where((element) => element.id!=newTask.id).toList();
    state=[newTask, ...state];
  }

  Future<int>removeTask(int id) async{
    final db=await _getDatabase();
    await db.update(('user_tasks'), {
      'status': 0,
    }, where: 'id=?', whereArgs: [id]);
    await db.close();
    var index=state.indexWhere((element) => element.id==id);
    state=state.where((element) => element.id!=id).toList();
    return index;
  }

  void removeUndoTask(Task task, int index) async{
    final db=await _getDatabase();
    await db.update(('user_tasks'), {
      'status': 1,
    }, where: 'id=?', whereArgs: [task.id]);
    await db.close();
    var temp=[...state];
    temp.insert(index, task);
    state=temp;
  }

    void loadCompletedTasks() async{
      final db=await _getDatabase();
      final data=await db.query('user_tasks', where: 'status=? AND completed=?', whereArgs: [1, 1]);
      await db.close();
      final tasks=data.map((row) => Task(
        id: row['id'] as int,
        task: row['task'] as String,
        updatedDate: row['updatedDate'] as String
      )).toList();
      state=tasks;
    }

    void completeTask(int id) async {
      final db=await _getDatabase();
      await db.update(('user_tasks'), {
      'completed': 1,
    }, where: 'id=?', whereArgs: [id]);
      await db.close();
     state=state.where((element) => element.id!=id).toList();
    }

    void unCompleteTask(int id) async{
      final db=await _getDatabase();
      await db.update(('user_tasks'), {
      'completed': 0,
    }, where: 'id=?', whereArgs: [id]);
      await db.close();
     state=state.where((element) => element.id!=id).toList();
    }
}

final userTasksProvider=StateNotifierProvider<UserTasksNotifier, List<Task>>((ref) => UserTasksNotifier());