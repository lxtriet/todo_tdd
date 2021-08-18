import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_tdd/core/core.dart';
import 'package:todo_tdd/features/home/data/data.dart';
import 'package:todo_tdd/features/home/data/models/my_task_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'task_local_datasource_test.mocks.dart';

@GenerateMocks([Box])
main() {
  late TaskLocalDataSourceImpl taskLocalDataSourceImpl;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    taskLocalDataSourceImpl = TaskLocalDataSourceImpl(mockBox);
  });

  final tMyTasks = [
    MyTaskModel(
      id: '123456',
      title: 'Sample title',
      description: 'Sample description',
      isCompleted: false,
    ),
  ];

  group('getAllTasks', () {
    test('should return all tasks when ', () async {
      // arrange
      when(mockBox.get(any)).thenReturn(fixture('my_tasks_cache.json'));
      // act
      final result = await taskLocalDataSourceImpl.getAllTasks();
      // assert
      verify(mockBox.get(CACHED_ALL_TASKS));
      expect(result, tMyTasks);
    });

    test('should throw a CacheException when there is no data in the cache', () async {
      // arrange
      when(mockBox.get(any)).thenReturn(null);
      // act
      final call = taskLocalDataSourceImpl.getAllTasks;
      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheAllTasks', () {
    final tCacheString = json.encode(tMyTasks.map((e) => e.toJson()).toList());

    test('should call the box to cache the data', () async {
      // arrange
      when(mockBox.put(CACHED_ALL_TASKS, tCacheString)).thenAnswer((_) async => true);
      // act
      await taskLocalDataSourceImpl.cacheAllTasks(tasks: tMyTasks);
      // assert
      verify(mockBox.put(CACHED_ALL_TASKS, tCacheString));
    });
  });
}
