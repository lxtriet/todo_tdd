import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd/core/core.dart';
import 'package:todo_tdd/features/home/domain/domain.dart';
import 'package:todo_tdd/features/home/home.dart';

import 'tasks_bloc_test.mocks.dart';

@GenerateMocks([GetAllTasksUseCase, UpdateTaskUseCase, CreateTaskUseCase])
void main() {
  late TasksBloc bloc;
  late MockGetAllTasksUseCase mockGetAllTasksUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;

  setUp(() {
    mockGetAllTasksUseCase = MockGetAllTasksUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    bloc = TasksBloc(
      createTaskUseCase: mockCreateTaskUseCase,
      getAllTasksUseCase: mockGetAllTasksUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
    );
  });

  test('initial state should be [TasksLoadInProgress]', () async {
    // arrage
    // act
    // assert
    expect(bloc.state, equals(TasksLoadInProgress()));
  });

  group('TasksLoaded event', () {
    final tMyTasks = [
      MyTask(id: '123456', title: 'Sample title', isCompleted: false),
    ];
    final tServerFailure = ServerFailure();
    final tCacheFailure = CacheFailure();

    test(
      'should call get all task usecase when bloc dispatch [TasksLoaded] event',
      () async {
        // arrange
        when(mockGetAllTasksUseCase.call(any)).thenAnswer((_) async => Right(tMyTasks));
        // act
        bloc.add(TasksLoaded());
        await untilCalled(mockGetAllTasksUseCase.call(any));
        // assert later
        verify(mockGetAllTasksUseCase.call(NoParam()));
      },
    );

    test(
      'should emit [TasksLoadSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetAllTasksUseCase.call(any)).thenAnswer((_) async => Right(tMyTasks));
        // assert later
        final expected = [
          TasksLoadSuccess(tMyTasks),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TasksLoaded());
      },
    );

    test(
      'should emit [TasksLoadFailure] when getting data return server failure',
      () async {
        // arrange
        when(mockGetAllTasksUseCase.call(any)).thenAnswer((_) async => Left(tServerFailure));
        // assert later
        final expected = [
          TasksLoadFailure(tServerFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TasksLoaded());
      },
    );

    test(
      'should emit [TasksLoadFailure] when getting data return cache failure',
      () async {
        // arrange
        when(mockGetAllTasksUseCase.call(any)).thenAnswer((_) async => Left(tCacheFailure));
        // assert later
        final expected = [
          TasksLoadFailure(tCacheFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TasksLoaded());
      },
    );
  });

  group('TaskAdded event', () {
    final tMyTask = MyTask(id: '123456', title: 'Sample title', isCompleted: false);
    final tServerFailure = ServerFailure();
    final tNetworkFailure = NetworkFailure();

    test(
      'should call create task usecase when bloc dispatch [TaskAdded] event',
      () async {
        // arrange
        when(mockCreateTaskUseCase.call(any)).thenAnswer((_) async => Right(tMyTask));
        // act
        bloc.add(TaskAdded(tMyTask));
        await untilCalled(mockCreateTaskUseCase.call(any));
        // assert later
        verify(mockCreateTaskUseCase.call(any));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, AddEditTaskSuccess] when task created successfully',
      () async {
        // arrange
        when(mockCreateTaskUseCase.call(any)).thenAnswer((_) async => Right(tMyTask));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          AddEditTaskSuccess(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskAdded(tMyTask));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, TaskAddedFailure] when task created return server failure',
      () async {
        // arrange
        when(mockCreateTaskUseCase.call(any)).thenAnswer((_) async => Left(tServerFailure));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          TaskAddedFailure(tServerFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskAdded(tMyTask));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, TaskAddedFailure] when task created return network failure',
      () async {
        // arrange
        when(mockCreateTaskUseCase.call(any)).thenAnswer((_) async => Left(tNetworkFailure));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          TaskAddedFailure(tNetworkFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskAdded(tMyTask));
      },
    );
  });

  group('TaskUpdated event', () {
    final tMyTask = MyTask(id: '123456', title: 'Sample title', isCompleted: false);
    final tServerFailure = ServerFailure();
    final tNetworkFailure = NetworkFailure();

    test(
      'should call update task usecase when bloc dispatch [TaskUpdated] event',
      () async {
        // arrange
        when(mockUpdateTaskUseCase.call(any)).thenAnswer((_) async => Right(true));
        // act
        bloc.add(TaskUpdated(tMyTask));
        await untilCalled(mockUpdateTaskUseCase.call(any));
        // assert later
        verify(mockUpdateTaskUseCase.call(any));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, AddEditTaskSuccess] when task updated successfully',
      () async {
        // arrange
        when(mockUpdateTaskUseCase.call(any)).thenAnswer((_) async => Right(true));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          AddEditTaskSuccess(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskUpdated(tMyTask));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, TaskUpdatedFailure] when task updated return server failure',
      () async {
        // arrange
        when(mockUpdateTaskUseCase.call(any)).thenAnswer((_) async => Left(tServerFailure));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          TaskUpdatedFailure(tServerFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskUpdated(tMyTask));
      },
    );

    test(
      'should emit [AddEditTaskInProgress, TaskAddedFailure] when task updated return network failure',
      () async {
        // arrange
        when(mockUpdateTaskUseCase.call(any)).thenAnswer((_) async => Left(tNetworkFailure));
        // assert later
        final expected = [
          AddEditTaskInProgress(),
          TaskUpdatedFailure(tNetworkFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(TaskUpdated(tMyTask));
      },
    );
  });
}
