import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../domain.dart';

abstract class TaskRepository {
  Future<Either<Failure, MyTask>> createTask({String? title, String? description});

  Future<Either<Failure, bool>> updateTask({String? id, bool? newStatus});

  Future<Either<Failure, List<MyTask>>> getAllTasks();
}
