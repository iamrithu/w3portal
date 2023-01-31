import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constant/const-var.dart';

class API {
  final dio = Dio(BaseOptions(
    connectTimeout: 30000,
    baseUrl: ConstVar.BASE_URL,
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
  ));
  Future authendication(String email, String password) async {
    try {
      var params = {"email": email, "password": password};
      Response response = await dio.post(
        "auth/login",
        data: jsonEncode(params),
      );

      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future notification(String? token) async {
    dio.options.headers["Authorization"] = "Bearer $token";
    try {
      Response response = await dio.get(
        "notification",
      );

      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future task(String? token) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      Response response = await dio.get(
        "task",
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future addTask(String? token, Map<String, dynamic> data) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    print(data);

    final formData = FormData.fromMap({
      "heading": data["heading"],
      "description": data["description"],
      "start_date": data["start_date"],
      "due_date": data["due_date"],
      // "without_duedate": data["without_duedate"],
      "project_id": data["project_id"],
      "category_id": data["category_id"],
      "priority": 1,
      "is_private": null,
      "billable": 0,
      "estimate_minutes": 0,
      "estimate_hours": 0,
      // "milestone_id": 0,
      // "repeat": 0,
      // "repeat_count": 0,
      // "repeat_type": 0,
      // "repeat_cycles": 0,
      "user_id[]": data["user_id[]"],
      // "task_labels": ',
    });

    try {
      Response response = await dio.post("task/store", data: formData);
      print("$response");
      return response;
    } on DioError catch (e) {
      print("${e.response}");

      return e.response;
    }
  }

  Future taskCategory(String? token) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      Response response = await dio.get(
        "task/list/category",
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future project(String? token) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      Response response = await dio.get(
        "task/list/projects",
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future employees(String? token) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      Response response = await dio.get(
        "task/list/employees",
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future attendence(String? token, String? date) async {
    dio.options.headers["Authorization"] = "Bearer $token";
    final formData = FormData.fromMap({"date": date});

    try {
      Response response = await dio.post("attendance/all", data: formData);
      print(response.data[1]);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
