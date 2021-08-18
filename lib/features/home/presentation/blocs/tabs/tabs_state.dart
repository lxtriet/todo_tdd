import 'package:equatable/equatable.dart';

import '../../../../../enums.dart';
import '../../../domain/domain.dart';

abstract class TabsState extends Equatable {
  const TabsState();

  @override
  List<Object> get props => [];
}

class TabsLoadDataInProgress extends TabsState {}

class TabsLoadDataSuccess extends TabsState {
  final List<MyTask> tasks;
  final TaskStatus currentStatus;

  const TabsLoadDataSuccess(
    this.tasks,
    this.currentStatus,
  );

  @override
  List<Object> get props => [tasks, currentStatus];
}
