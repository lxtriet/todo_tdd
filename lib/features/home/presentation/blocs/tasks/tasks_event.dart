import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class TasksLoaded extends TasksEvent {}

class TaskAdded extends TasksEvent {
  final MyTask task;

  const TaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class TaskUpdated extends TasksEvent {
  final MyTask task;

  const TaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}
