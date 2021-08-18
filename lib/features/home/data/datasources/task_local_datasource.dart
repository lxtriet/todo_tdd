import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/core.dart';
import '../../home.dart';

const String CACHED_ALL_TASKS = 'CACHED_ALL_TASKS';

abstract class TaskLocalDataSource {
  /// Gets the cache [MyTask] which was gotten the last time
  /// the user has an internet connection.
  /// Throw [CacheException] if no cached data is present
  Future<List<MyTaskModel>> getAllTasks();

  Future<void> cacheAllTasks({required List<MyTaskModel> tasks});
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  TaskLocalDataSourceImpl(this.box);

  final Box box;

  @override
  Future<void> cacheAllTasks({required List<MyTaskModel> tasks}) {
    return box.put(
      CACHED_ALL_TASKS,
      json.encode(tasks.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<MyTaskModel>> getAllTasks() async {
    final modelsString = box.get(CACHED_ALL_TASKS);
    if (modelsString == null) {
      throw CacheException();
    }
    return json.decode(modelsString).map<MyTaskModel>((e) => MyTaskModel.fromJson(e)).toList();
  }
}
