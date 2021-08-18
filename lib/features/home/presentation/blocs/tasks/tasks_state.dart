import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/domain.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksLoadInProgress extends TasksState {}

class AddEditTaskInProgress extends TasksState {}

class AddEditTaskSuccess extends TasksState {}

class TasksLoadSuccess extends TasksState {
  final List<MyTask> tasks;

  const TasksLoadSuccess([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];
}

class TasksFailure extends TasksState {
  final Failure failure;

  const TasksFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class TasksLoadFailure extends TasksFailure {
  TasksLoadFailure(Failure failure) : super(failure);
}

class TaskAddedFailure extends TasksFailure {
  TaskAddedFailure(Failure failure) : super(failure);
}

class TaskUpdatedFailure extends TasksFailure {
  TaskUpdatedFailure(Failure failure) : super(failure);
}
