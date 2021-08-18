import 'package:todo_tdd/features/home/domain/domain.dart';

extension TaskExt on MyTask {
  int get priority {
    return (isCompleted ?? false) ? 1 : 0;
  }
}
