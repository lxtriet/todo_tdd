import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../core/core.dart';
import '../../../domain/domain.dart';
import 'tasks.dart';
import 'tasks_event.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final CreateTaskUseCase createTaskUseCase;

  late StreamSubscription tasksSubscription;

  TasksBloc({
    required this.getAllTasksUseCase,
    required this.updateTaskUseCase,
    required this.createTaskUseCase,
  }) : super(TasksLoadInProgress()) {
    tasksSubscription = stream.listen((state) {
      if (state is AddEditTaskSuccess || state is TaskAddedFailure || state is TaskUpdatedFailure) {
        add(TasksLoaded());
      }
    });
  }

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is TasksLoaded) {
      yield* _mapTasksLoadedToState();
    } else if (event is TaskAdded) {
      yield* _mapTaskAddedToState(event);
    } else if (event is TaskUpdated) {
      yield* _mapTaskUpdatedToState(event);
    }
  }

  Stream<TasksState> _mapTasksLoadedToState() async* {
    final tasksEither = await getAllTasksUseCase(NoParam());
    yield* tasksEither.fold((failure) async* {
      yield TasksLoadFailure(failure);
    }, (tasks) async* {
      yield TasksLoadSuccess(tasks);
    });
  }

  Stream<TasksState> _mapTaskAddedToState(TaskAdded event) async* {
    yield AddEditTaskInProgress();
    final addTaskEither = await createTaskUseCase(
      CreateTaskParams(
        title: event.task.title,
        description: event.task.description,
      ),
    );
    yield* addTaskEither.fold((failure) async* {
      yield TaskAddedFailure(failure);
    }, (task) async* {
      yield AddEditTaskSuccess();
    });
  }

  Stream<TasksState> _mapTaskUpdatedToState(TaskUpdated event) async* {
    yield AddEditTaskInProgress();
    final updateTaskEither = await updateTaskUseCase(
      UpdateTaskParams(
        id: event.task.id,
        newStatus: event.task.isCompleted,
      ),
    );
    yield* updateTaskEither.fold((failure) async* {
      yield TaskUpdatedFailure(failure);
    }, (r) async* {
      yield AddEditTaskSuccess();
    });
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    return super.close();
  }
}
