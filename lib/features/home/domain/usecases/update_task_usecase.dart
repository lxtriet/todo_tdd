import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../domain.dart';

class UpdateTaskUseCase extends UseCase<bool, UpdateTaskParams> {
  final TaskRepository taskRepository;

  UpdateTaskUseCase(this.taskRepository);

  @override
  Future<Either<Failure, bool>> call(UpdateTaskParams params) {
    return taskRepository.updateTask(id: params.id, newStatus: params.newStatus);
  }
}

class UpdateTaskParams extends Equatable {
  UpdateTaskParams({required this.id, required this.newStatus});

  final String? id;
  final bool? newStatus;

  @override
  List<Object?> get props => [id, newStatus];
}
