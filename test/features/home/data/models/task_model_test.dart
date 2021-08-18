import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd/features/home/data/models/my_task_model.dart';
import 'package:todo_tdd/features/home/domain/domain.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final tTaskModel = MyTaskModel(
    id: '123456',
    title: 'Sample title',
    description: 'Sample description',
    isCompleted: false,
  );

  test('should be a abstract of [Task] entity', () {
    expect(tTaskModel, isA<MyTask>());
  });

  group('fromJson', () {
    test('should return valid model when JSON response is valid', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('my_task.json'));
      // act
      final result = MyTaskModel.fromJson(jsonMap);
      // assert
      expect(result, equals(tTaskModel));
    });
  });

  group('toJson', () {
    test('toJson should return a JSON map containing the proper data', () {
      // act
      final result = tTaskModel.toJson();
      // assert
      final expectedMap = {
        '_id': '123456',
        'title': 'Sample title',
        'description': 'Sample description',
        'isCompleted': false,
      };
      expect(result, equals(expectedMap));
    });
  });
}
