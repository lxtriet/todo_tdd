import 'package:flutter/material.dart';
import 'package:todo_tdd/enums.dart';

class StatusEmpty extends StatelessWidget {
  final TaskStatus? status;
  const StatusEmpty({Key? key, this.status = TaskStatus.all}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('There are no ${_getAdjectiveOfTask()}tasks here'),
    );
  }

  String _getAdjectiveOfTask() {
    if (status == TaskStatus.all) return '';
    if (status == TaskStatus.completed) return 'completed ';
    return 'incomplete ';
  }
}
