import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _loginCode = "";

  void getToken() async {
    var pref = await SharedPreferences.getInstance();
    var data = {"passcode": _loginCode};
    var res = await Dio().post("", data: data);
    print(res.statusMessage);
    if (res.statusMessage != "Invalid Passcode") {
      pref.setString("token", res.data['token']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  child: TextField(
                    onChanged: (val) => setState(() {
                      _loginCode = val;
                    }),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.login_rounded),
                      hintText: "Enter Login Code",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  child: ElevatedButton(
                    child: Text("Login"),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
