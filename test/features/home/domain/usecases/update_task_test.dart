import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:todo_tdd/features/home/domain/repositories/task_repository.dart';
import 'package:todo_tdd/features/home/domain/usecases/update_task_usecase.dart';

import 'update_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
main() {
  late UpdateTaskUseCase usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = UpdateTaskUseCase(mockTaskRepository);
  });

  final tId = '123124124124214';
  final tNewStatus = false;
  final tSuccessResult = true;
  final tFailResult = false;

  test('should return true after update task successfully', () async {
    // arrange
    when(mockTaskRepository.updateTask(id: tId, newStatus: tNewStatus)).thenAnswer((_) async => Right(tSuccessResult));
    // act
    final result = await usecase.call(UpdateTaskParams(id: tId, newStatus: tNewStatus));
    // assert
    verify(mockTaskRepository.updateTask(id: tId, newStatus: tNewStatus));
    expect(result, equals(Right(tSuccessResult)));
    verifyNoMoreInteractions(mockTaskRepository);
  });

  test('should return false when failure to update task', () async {
    // arrange
    when(mockTaskRepository.updateTask(id: tId, newStatus: tNewStatus)).thenAnswer((_) async => Right(tFailResult));
    // act
    final result = await usecase.call(UpdateTaskParams(id: tId, newStatus: tNewStatus));
    // assert
    verify(mockTaskRepository.updateTask(id: tId, newStatus: tNewStatus));
    expect(result, equals(Right(tFailResult)));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
