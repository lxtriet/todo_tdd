import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_tdd/core/core.dart';
import 'package:todo_tdd/features/home/data/data.dart';
import 'package:todo_tdd/features/home/data/models/my_task_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'task_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
main() {
  late TaskRemoteDataSourceImpl taskRemoteDataSourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    taskRemoteDataSourceImpl = TaskRemoteDataSourceImpl(mockClient);
  });

  final tMyTask = MyTaskModel(
    id: '123456',
    title: 'Sample title',
    description: 'Sample description',
    isCompleted: false,
  );

  final tMyTasks = [
    tMyTask,
  ];

  group('getAllTasks', () {
    final tGetAllUrl = 'https://todotdd.herokuapp.com/tasks';

    void setUpMockHttlClientGetSuccess200() {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('my_tasks.json'), 200));
    }

    void setUpMockHttlClientGetFailure404() {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something wrong', 404));
    }

    test('''should perform a GET request on url [https://todotdd.herokuapp.com/tasks] 
      with status = null and with application/json header''', () async {
      // arrange
      setUpMockHttlClientGetSuccess200();
      // act
      taskRemoteDataSourceImpl.getAllTasks();
      // assert
      verify(mockClient.get(
        Uri.parse(tGetAllUrl),
        headers: {
          'Content-Type': 'applcation/json',
        },
      ));
    });

    group('check with response code is 200', () {
      test('''should return all tasks when response code is 200 (success)''', () async {
        // arrange
        setUpMockHttlClientGetSuccess200();
        // act
        final result = await taskRemoteDataSourceImpl.getAllTasks();
        // assert
        expect(result, equals(tMyTasks));
      });
    });

    group('check with response code is 404 or others', () {
      test('''should throw a ServerException when the response code is 404 or other''', () async {
        // arrange
        setUpMockHttlClientGetFailure404();
        // act
        final call = taskRemoteDataSourceImpl.getAllTasks;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      });
    });
  });

  group('createTasks', () {
    final tCreateUrl = 'https://todotdd.herokuapp.com/tasks';
    final tTitle = 'Sample title';
    final tDescription = 'Sample description';

    void setUpMockHttlClientPostSuccess200() {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('my_task.json'), 200));
    }

    test('''should perform a POST request on a URL with title in body and with application/json header''', () async {
      // arrange
      setUpMockHttlClientPostSuccess200();
      // act
      taskRemoteDataSourceImpl.createTask(title: tTitle, description: tDescription);
      // assert
      verify(mockClient.post(
        Uri.parse(tCreateUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            'title': tTitle,
            'description': tDescription,
          },
        ),
      ));
    });

    test('''should return valid model when response code is 200 (success)''', () async {
      // arrange
      setUpMockHttlClientPostSuccess200();
      // act
      final result = await taskRemoteDataSourceImpl.createTask(title: tTitle, description: tDescription);
      // assert
      expect(result, equals(tMyTask));
    });

    test('''should throw a ServerException when the response code is 404 or other''', () async {
      // arrange
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something wrong', 404));
      // act
      final call = taskRemoteDataSourceImpl.createTask;
      // assert
      expect(() => call(title: tTitle, description: tDescription), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('updateTask', () {
    final tUpdateUrl = 'https://todotdd.herokuapp.com/tasks';
    final tNewStatus = true;
    final tId = '123456';

    void setUpMockHttlClientPutSuccess200() {
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('my_task.json'), 200));
    }

    test('''should perform a PUT request on a URL with id at the end point and new status body
    with application/json header''', () async {
      // arrange
      setUpMockHttlClientPutSuccess200();
      // act
      taskRemoteDataSourceImpl.updateTask(id: tId, newStatus: tNewStatus);
      // assert
      verify(mockClient.put(
        Uri.parse('$tUpdateUrl/$tId'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            'isCompleted': tNewStatus,
          },
        ),
      ));
    });

    test('''should return true when response code is 200 (success)''', () async {
      // arrange
      setUpMockHttlClientPutSuccess200();
      // act
      final result = await taskRemoteDataSourceImpl.updateTask(id: tId, newStatus: tNewStatus);
      // assert
      expect(result, equals(true));
    });

    test('''should throw a ServerException when the response code is 404 or other''', () async {
      // arrange
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something wrong', 404));
      // act
      final call = taskRemoteDataSourceImpl.updateTask;
      // assert
      expect(() => call(id: tId, newStatus: tNewStatus), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
