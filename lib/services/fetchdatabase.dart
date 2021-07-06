import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdb_flutter/constants.dart';

class FetchDatabase {
  final _databaseController = StreamController<List>();

  Stream<List> get databaseStream => _databaseController.stream;

  FetchDatabase() {
    makeApiCall();
  }

  void makeApiCall() async {
    var data = await http.get(Uri.parse(Constants().FetchDatabaseUrl),
        headers: {
          "auth-token":
              "12998c017066eb0d2a70b94e6ed3192985855ce390f321bbdb832022888bd251"
        });
    if (data.statusCode == 200) {
      List jill = json.decode(data.body);
      _databaseController.sink.add(jill);
    }
  }

  void dispose() {
    _databaseController.close();
  }
}
