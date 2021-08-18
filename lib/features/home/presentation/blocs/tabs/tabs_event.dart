import 'package:equatable/equatable.dart';

import '../../../../../enums.dart';
import '../../../domain/domain.dart';

abstract class TabsEvent extends Equatable {
  const TabsEvent();
}

class TabsChanged extends TabsEvent {
  final TaskStatus status;

  const TabsChanged(this.status);

  @override
  List<Object> get props => [status];
}

class TasksUpdated extends TabsEvent {
  final List<MyTask> tasks;

  const TasksUpdated(this.tasks);

  @override
  List<Object> get props => [tasks];
}
