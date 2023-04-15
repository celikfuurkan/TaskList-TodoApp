// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_todo_app/models/task_model.dart';
import 'package:hive_flutter/adapters.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

/*
class MockData extends LocalStorage {
  @override
  Future<void> addTask({required Task task}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTask({required Task task}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getAllTask() {
    throw UnimplementedError();
  }

  @override
  Future<Task> getTask({required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTask({required Task task}) {
    throw UnimplementedError();
  }
}*/

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
