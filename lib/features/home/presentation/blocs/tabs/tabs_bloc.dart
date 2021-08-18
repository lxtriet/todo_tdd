import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../enums.dart';
import '../../../../../extensions/task_extension.dart';
import '../../../domain/domain.dart';
import '../blocs.dart';
import 'tabs_event.dart';
import 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  final TasksBloc tasksBloc;
  late StreamSubscription tasksSubscription;

  TabsBloc({required this.tasksBloc})
      : super(
          tasksBloc.state is TasksLoadSuccess
              ? TabsLoadDataSuccess(
                  (tasksBloc.state as TasksLoadSuccess).tasks,
                  TaskStatus.all,
                )
              : TabsLoadDataInProgress(),
        ) {
    tasksSubscription = tasksBloc.stream.listen((state) {
      if (state is TasksLoadSuccess) {
        add(TasksUpdated(state.tasks));
      }
    });
  }

  @override
  Stream<TabsState> mapEventToState(TabsEvent event) async* {
    if (event is TabsChanged) {
      yield* _mapStatusToState(event);
    } else if (event is TasksUpdated) {
      yield* _mapTasksUpdatedToState(event);
    }
  }

  Stream<TabsState> _mapStatusToState(
    TabsChanged event,
  ) async* {
    final tasksState = tasksBloc.state;
    if (tasksState is TasksLoadSuccess) {
      yield TabsLoadDataSuccess(
        _mapTasksToStatus(
          tasksState.tasks,
          event.status,
        ),
        event.status,
      );
    }
  }

  Stream<TabsState> _mapTasksUpdatedToState(
    TasksUpdated event,
  ) async* {
    final status = state is TabsLoadDataSuccess ? (state as TabsLoadDataSuccess).currentStatus : TaskStatus.all;
    yield TabsLoadDataSuccess(
      _mapTasksToStatus(
        (tasksBloc.state as TasksLoadSuccess).tasks,
        status,
      ),
      status,
    );
  }

  List<MyTask> _mapTasksToStatus(List<MyTask> tasks, TaskStatus status) {
    return tasks.where((task) {
      if (status == TaskStatus.all) {
        return true;
      } else if (status == TaskStatus.completed) {
        return task.isCompleted ?? true;
      } else {
        return !(task.isCompleted ?? false);
      }
    }).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    return super.close();
  }
}
