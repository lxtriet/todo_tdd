import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../domain.dart';

class GetAllTasksUseCase extends UseCase<List<MyTask>, NoParam> {
  final TaskRepository taskRepository;

  GetAllTasksUseCase(this.taskRepository);

  @override
  Future<Either<Failure, List<MyTask>>> call(NoParam params) {
    return taskRepository.getAllTasks();
  }
}

