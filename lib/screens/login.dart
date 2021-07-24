import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdb_flutter/screens/home.dart';
import 'package:pdb_flutter/services/fetchdatabase.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _loginCode = "";

  void login() {
    var dbService = FetchDatabase(false);
    dbService.getToken(context, _loginCode).then(
          (_) => Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (c) => Home(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Container(
                child: Image.asset(
                  "assets/pdb_icon.png",
                  height: 150.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100.0,
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
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 120.0,
                  child: ElevatedButton(
                    child: Text("Login"),
                    onPressed: () => login(),
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
