import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_tdd/core/core.dart';

import 'package:todo_tdd/features/home/domain/entities/task.dart';
import 'package:todo_tdd/features/home/domain/repositories/task_repository.dart';
import 'package:todo_tdd/features/home/domain/usecases/get_all_tasks_usecase.dart';

import 'get_all_tasks_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
main() {
  late GetAllTasksUseCase usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = GetAllTasksUseCase(mockTaskRepository);
  });

  final tListTask = <MyTask>[
    MyTask(id: '123456', title: 'Sample title', isCompleted: false),
  ];

  test('should get all tasks from the repository', () async {
    // arrange
    when(mockTaskRepository.getAllTasks()).thenAnswer((_) async => Right(tListTask));
    // act
    final result = await usecase.call(NoParam());
    // assert
    verify(mockTaskRepository.getAllTasks());
    expect(result, equals(Right(tListTask)));
  });
}
