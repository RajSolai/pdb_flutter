import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pdb_flutter/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchDatabase {
  final _databaseController = StreamController<List>();

  Stream<List> get databaseStream => _databaseController.stream;

  FetchDatabase() {
    makeApiCall();
  }

  void makeApiCall() async {
    var prefs = await SharedPreferences.getInstance();
    var opts = BaseOptions(headers: {"auth-token": prefs.getString("token")});
    var data = await Dio(opts).get(Constants().FetchDatabaseUrl);
    if (data.statusCode == 200) {
      _databaseController.sink.add(data.data);
    }
  }

  void dispose() {
    _databaseController.close();
  }
}
