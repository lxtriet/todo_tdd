import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../../home.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource taskRemoteDataSource;
  final TaskLocalDataSource taskLocalDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.networkInfo,
    required this.taskLocalDataSource,
    required this.taskRemoteDataSource,
  });

  @override
  Future<Either<Failure, MyTask>> createTask({String? title, String? description}) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        final createTask = await taskRemoteDataSource.createTask(title: title, description: description);
        return Right(createTask);
      }
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyTask>>> getAllTasks() async {
    final isConnected = await networkInfo.isConnected;
    try {
      if (isConnected) {
        final remoteTasks = await taskRemoteDataSource.getAllTasks();
        taskLocalDataSource.cacheAllTasks(tasks: remoteTasks);
        return Right(remoteTasks);
      } else {
        final localTasks = await taskLocalDataSource.getAllTasks();
        return Right(localTasks);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask({String? id, bool? newStatus}) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        final updateTask = await taskRemoteDataSource.updateTask(id: id, newStatus: newStatus);
        return Right(updateTask);
      }
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
