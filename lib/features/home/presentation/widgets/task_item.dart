import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class TaskItem extends StatelessWidget {
  final ValueChanged<bool?> onCheckboxChanged;
  final MyTask task;

  TaskItem({
    Key? key,
    required this.onCheckboxChanged,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      child: ListTile(
        leading: Checkbox(
          key: ValueKey(task.id),
          value: task.isCompleted,
          onChanged: onCheckboxChanged,
        ),
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            task.title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        subtitle: (task.description != null && task.description!.isNotEmpty)
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              )
            : null,
      ),
    );
  }
}
