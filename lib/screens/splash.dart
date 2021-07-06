import 'package:flutter/material.dart';
import 'package:pdb_flutter/screens/home.dart';
import 'package:pdb_flutter/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late String _uid;

  Future<void> getToken() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      _uid = pref.getString("token") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getToken().then((_) => {
          if (_uid.length == 0)
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()))
            }
          else
            {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Text("welcome to splash")],
        ),
      ),
    );
  }
}
