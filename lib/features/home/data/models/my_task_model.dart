import '../../domain/domain.dart';

class MyTaskModel extends MyTask {
  MyTaskModel({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) : super(id: id, title: title, description: description, isCompleted: isCompleted);

  factory MyTaskModel.fromJson(Map<String, dynamic> json) => MyTaskModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        isCompleted: json['isCompleted'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };
}
