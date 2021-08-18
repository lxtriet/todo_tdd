import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../domain.dart';

class CreateTaskUseCase extends UseCase<MyTask, CreateTaskParams> {
  final TaskRepository taskRepository;

  CreateTaskUseCase(this.taskRepository);

  @override
  Future<Either<Failure, MyTask>> call(CreateTaskParams params) {
    return taskRepository.createTask(title: params.title, description: params.description);
  }
}

class CreateTaskParams extends Equatable {
  CreateTaskParams({this.title, this.description});

  final String? title;
  final String? description;

  @override
  List<Object?> get props => [title, description];
}
