import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'dependencies/app_dependencies.dart' as di;
import 'features/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await di.init();

  runApp(
    BlocProvider<TasksBloc>(
      create: (context) => di.injector()..add(TasksLoaded()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<TabsBloc>(
        create: (context) => TabsBloc(
          tasksBloc: BlocProvider.of<TasksBloc>(context),
        ),
        child: HomePage(),
      ),
    );
  }
}
