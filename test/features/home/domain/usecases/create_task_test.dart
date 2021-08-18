import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:todo_tdd/features/home/domain/repositories/task_repository.dart';
import 'package:todo_tdd/features/home/domain/usecases/create_task_usecase.dart';
import 'package:todo_tdd/features/home/home.dart';

import 'create_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
main() {
  late CreateTaskUseCase usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = CreateTaskUseCase(mockTaskRepository);
  });

  final tTitle = "Sample title";
  final tDescription = "Sample description";
  final tMyTaskModel = MyTaskModel(id: '123456', title: tTitle, isCompleted: false, description: tDescription);

  test('should return valid model after creating task successfully', () async {
    // arrange
    when(mockTaskRepository.createTask(title: tTitle, description: tDescription))
        .thenAnswer((_) async => Right(tMyTaskModel));
    // act
    final result = await usecase.call(CreateTaskParams(title: tTitle, description: tDescription));
    // assert
    verify(mockTaskRepository.createTask(title: tTitle, description: tDescription));
    expect(result, equals(Right(tMyTaskModel)));
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
