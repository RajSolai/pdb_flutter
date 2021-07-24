import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchDatabase {
  final _databaseController = StreamController<List>();
  static String apiUrl = "https://pdb-api.eu-gb.cf.appdomain.cloud";

  Stream<List> get databaseStream => _databaseController.stream;

  FetchDatabase(bool isHome) {
    if (isHome) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        makeApiCall();
      });
    }
  }

  void makeApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    Response data = await Dio(opts).get(apiUrl);
    if (data.statusCode == 200) {
      _databaseController.sink.add(data.data);
    }
  }

  Future<bool> getToken(BuildContext context, String loginCode) async {
    const snackBar = SnackBar(
      content: Text("Logging in...."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> data = {"passcode": loginCode};
    Response res = await Dio()
        .post("$apiUrl/login", data: data);
    if (res.statusMessage != "Invalid Passcode") {
      pref.setString("token", res.data['token']);
      return true;
    }
    return false;
  }

  void addProject(
    String projectType,
    String projectName,
    String projectDesc,
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    Map<String, String> data = {"name": projectName, "desc": projectDesc};
    Response res = await Dio(opts).post("$apiUrl/$projectType", data: data);
    if (res.data != "Access Denied") {
      const snackBar = SnackBar(content: Text("Project Created Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void saveLists(
    String listId,
    List todoList,
    List completedList,
    BuildContext context,
  ) async {
    Map<String, List> newBody = {
      "todoList": todoList,
      "completedList": completedList
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    Response res = await Dio(opts).put(
      "$apiUrl/list/$listId",
      data: newBody,
    );
    if (res.statusCode == 200) {
      makeApiCall();
      const snackBar = SnackBar(
        content: Text("Changes Made Successfully 🎉️"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<Response> fetchProjectBody(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    Response res = await Dio(opts).get(
      "$apiUrl/database/$id",
    );
    return res;
  }

  Future<Response> fetchListBody(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    Response res = await Dio(opts).get(
      "$apiUrl/database/$id",
    );
    return res;
  }

  Future<Response> saveProjectBody(Map body, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions opts =
        BaseOptions(headers: {"auth-token": prefs.getString("token")});
    var res = await Dio(opts).put(
      "$apiUrl/project/$id",
      data: body,
    );
    return res;
  }

  void dispose() {
    _databaseController.close();
  }
}
