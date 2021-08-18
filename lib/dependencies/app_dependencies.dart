import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/core.dart';
import '../features/home/home.dart';

const String HIVE_TASKS = 'HIVE_TASKS';

final injector = GetIt.instance;

Future<void> init() async {
  // Blocs
  injector.registerFactory(
    () => TasksBloc(
      createTaskUseCase: injector(),
      updateTaskUseCase: injector(),
      getAllTasksUseCase: injector(),
    ),
  );

  // Usecases
  injector.registerLazySingleton((() => CreateTaskUseCase(injector())));
  injector.registerLazySingleton(() => UpdateTaskUseCase(injector()));
  injector.registerLazySingleton(() => GetAllTasksUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      networkInfo: injector(),
      taskLocalDataSource: injector(),
      taskRemoteDataSource: injector(),
    ),
  );

  // Cores
  final box = await Hive.openBox(HIVE_TASKS);
  injector.registerLazySingleton(() => box, instanceName: HIVE_TASKS);
  injector.registerLazySingleton(() => http.Client());
  injector.registerLazySingleton(() => InternetConnectionChecker());
  injector.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()));

  // Datasources
  injector.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(injector()));
  injector
      .registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(injector(instanceName: HIVE_TASKS)));
}
