import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../home.dart';

const String BASE_URL = 'https://todotdd.herokuapp.com';

abstract class TaskRemoteDataSource {
  /// Calls the https://todotdd.herokuapp.com/tasks endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<MyTaskModel> createTask({String? title, String? description});

  /// Calls the https://todotdd.herokuapp.com/tasks endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<bool> updateTask({String? id, bool? newStatus});

  /// Calls the https://todotdd.herokuapp.com/tasks endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<List<MyTaskModel>> getAllTasks();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<MyTaskModel> createTask({String? title, String? description}) async {
    final Map<String, dynamic> data = {'title': title};
    if (description != null) {
      data['description'] = description;
    }

    final response = await client.post(
      Uri.parse('$BASE_URL/tasks'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return MyTaskModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<List<MyTaskModel>> getAllTasks() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tasks'),
      headers: {
        'Content-Type': 'applcation/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body).map<MyTaskModel>((e) => MyTaskModel.fromJson(e)).toList();
    }
    throw ServerException();
  }

  @override
  Future<bool> updateTask({String? id, bool? newStatus}) async {
    final response = await client.put(
      Uri.parse('$BASE_URL/tasks/$id'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          'isCompleted': newStatus ?? false,
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw ServerException();
  }
}
