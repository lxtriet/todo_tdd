import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../enums.dart';
import '../../../../mixins/bottom_sheet_mixin.dart';
import '../../home.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BottomSheetMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<TasksBloc>(context).stream.listen((state) {
      if (state is AddEditTaskInProgress) {
        LoadingDialog.show(context);
      } else {
        LoadingDialog.close(context);
      }

      if (state is TasksFailure) {
        AppSnackBar.showError(context, message: _getMessageFromFailure(state.failure));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TasksList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomBottomSheet(context, AddTaskContainer(
            onSave: (title, description) {
              BlocProvider.of<TasksBloc>(context).add(
                TaskAdded(MyTask(title: title, description: description)),
              );
            },
          ));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(
        onItemSelected: (index) {
          BlocProvider.of<TabsBloc>(context).add(TabsChanged(TaskStatus.values[index]));
        },
        items: [
          BottomNavBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.event_note_outlined),
            title: Text('All'),
          ),
          BottomNavBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.event),
            title: Text('Incomplete'),
          ),
          BottomNavBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.event_available),
            title: Text('Completed'),
          ),
        ],
      ),
    );
  }

  String _getMessageFromFailure(Failure failure) {
    if (failure is ServerFailure) {
      return 'Sorry! Server error occured';
    } else if (failure is CacheFailure) {
      return 'We need internet connection to fetch data';
    } else if (failure is NetworkFailure) {
      return 'We need a network connection to perform this action';
    } else {
      return 'Some unexpected error occured!';
    }
  }
}
