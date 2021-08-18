import 'package:equatable/equatable.dart';

class MyTask extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final bool? isCompleted;

  MyTask({this.id, this.title, this.description, this.isCompleted});

  @override
  List<Object?> get props => [id, title, description, isCompleted];

  MyTask copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return MyTask(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
