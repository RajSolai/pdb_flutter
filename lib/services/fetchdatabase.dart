import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchDatabase {
  final _databaseController = StreamController<List>();
  static String apiUrl = "https://fast-savannah-26464.herokuapp.com";

  Stream<List> get databaseStream => _databaseController.stream;

  FetchDatabase() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      makeApiCall();
    });
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

  void dispose() {
    _databaseController.close();
  }
}
