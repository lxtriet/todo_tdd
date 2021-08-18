import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_tdd/core/core.dart';
import 'package:todo_tdd/core/network/network_info.dart';
import 'package:todo_tdd/features/home/data/data.dart';
import 'package:todo_tdd/features/home/home.dart';

import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskRemoteDataSource, TaskLocalDataSource, NetworkInfo])
main() {
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late TaskRepositoryImpl taskRepositoryImpl;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    taskRepositoryImpl = TaskRepositoryImpl(
      networkInfo: mockNetworkInfo,
      taskLocalDataSource: mockTaskLocalDataSource,
      taskRemoteDataSource: mockTaskRemoteDataSource,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getAllTasks', () {
    final tListTask = <MyTaskModel>[
      MyTaskModel(id: '123456', title: 'Sample title', isCompleted: false, description: ''),
    ];

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockTaskRemoteDataSource.getAllTasks()).thenAnswer((_) async => tListTask);
      // act
      taskRepositoryImpl.getAllTasks();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote datasource successfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.getAllTasks()).thenAnswer((_) async => tListTask);
        // act
        final result = await taskRepositoryImpl.getAllTasks();
        // assert
        verify(mockTaskRemoteDataSource.getAllTasks());
        expect(result, equals(Right(tListTask)));
      });

      test('should cache data locally when the call to remote datasource is successfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.getAllTasks()).thenAnswer((_) async => tListTask);
        // act
        await taskRepositoryImpl.getAllTasks();
        // assert
        verify(mockTaskRemoteDataSource.getAllTasks());
        verify(mockTaskLocalDataSource.cacheAllTasks(tasks: tListTask));
      });

      test('should cache data locally when the call to remote datasource is successfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.getAllTasks()).thenAnswer((_) async => tListTask);
        // act
        await taskRepositoryImpl.getAllTasks();
        // assert
        verify(mockTaskRemoteDataSource.getAllTasks());
        verify(mockTaskLocalDataSource.cacheAllTasks(tasks: tListTask));
      });
    });

    runTestOffline(() {
      test('should return local data when the call to local datasource successfully', () async {
        // arrange
        when(mockTaskLocalDataSource.getAllTasks()).thenAnswer((_) async => tListTask);
        // act
        final result = await taskRepositoryImpl.getAllTasks();
        // assert
        verify(mockTaskLocalDataSource.getAllTasks());
        expect(result, equals(Right(tListTask)));
      });

      test('should return cache failure when the call to local datasource is unsuccessfully', () async {
        // arrange
        when(mockTaskLocalDataSource.getAllTasks()).thenThrow(CacheException());
        // act
        final result = await taskRepositoryImpl.getAllTasks();
        // assert
        verify(mockTaskLocalDataSource.getAllTasks());
        expect(result, equals(Left(CacheFailure())));
        verifyZeroInteractions(mockTaskRemoteDataSource);
      });
    });
  });

  group('createTask', () {
    final tTitle = 'Sample title';
    final tDescription = 'Sample description';
    final tMyTaskModel = MyTaskModel(id: '123456', title: tTitle, isCompleted: false, description: tDescription);

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription))
          .thenAnswer((_) async => tMyTaskModel);
      // act
      taskRepositoryImpl.createTask(title: tTitle, description: tDescription);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return valid model when the call to remote datasource is successfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription))
            .thenAnswer((_) async => tMyTaskModel);
        // act
        final result = await taskRepositoryImpl.createTask(title: tTitle, description: tDescription);
        // assert
        verify(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription));
        expect(result, equals(Right(tMyTaskModel)));
      });

      test('should return server failure when the call to remote datasource is unsuccessfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription))
            .thenThrow(ServerException());
        // act
        final result = await taskRepositoryImpl.createTask(title: tTitle, description: tDescription);
        // assert
        verify(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return network failure when network connection is not available', () async {
        // arrange
        when(mockTaskRemoteDataSource.createTask(title: tTitle, description: tDescription))
            .thenAnswer((_) async => tMyTaskModel);
        // act
        final result = await taskRepositoryImpl.createTask(title: tTitle, description: tDescription);
        // assert
        expect(result, equals(Left(NetworkFailure())));
        verifyZeroInteractions(mockTaskRemoteDataSource);
      });
    });
  });

  group('updateTask', () {
    final tId = '123456';
    final tNewStatus = true;

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus)).thenAnswer((_) async => true);
      // act
      taskRepositoryImpl.updateTask(id: tId, newStatus: tNewStatus);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return true when the call to remote datasource is successfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus)).thenAnswer((_) async => true);
        // act
        final result = await taskRepositoryImpl.updateTask(id: tId, newStatus: tNewStatus);
        // assert
        verify(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus));
        expect(result, equals(Right(true)));
      });

      test('should return server failure when the call to remote datasource is unsuccessfully', () async {
        // arrange
        when(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus)).thenThrow(ServerException());
        // act
        final result = await taskRepositoryImpl.updateTask(id: tId, newStatus: tNewStatus);
        // assert
        verify(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return network failure when network connection is not available', () async {
        // arrange
        when(mockTaskRemoteDataSource.updateTask(id: tId, newStatus: tNewStatus)).thenAnswer((_) async => true);
        // act
        final result = await taskRepositoryImpl.updateTask(id: tId, newStatus: tNewStatus);
        // assert
        expect(result, equals(Left(NetworkFailure())));
        verifyZeroInteractions(mockTaskRemoteDataSource);
      });
    });
  });
}
