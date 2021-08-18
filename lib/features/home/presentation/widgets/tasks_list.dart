import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tdd/features/home/presentation/widgets/status_empty.dart';

import '../../home.dart';
import 'task_item.dart';

class TasksList extends StatelessWidget {
  TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, TabsState>(
      builder: (context, state) {
        if (state is TabsLoadDataInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TabsLoadDataSuccess) {
          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return StatusEmpty(
              status: state.currentStatus,
            );
          }
          return ListView.builder(
            key: UniqueKey(),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onCheckboxChanged: (_) {
                  final oldStatus = task.isCompleted;
                  if (oldStatus != null) {
                    BlocProvider.of<TasksBloc>(context).add(
                      TaskUpdated(task.copyWith(isCompleted: !oldStatus)),
                    );
                  }
                },
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
