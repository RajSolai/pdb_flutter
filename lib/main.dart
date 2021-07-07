import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdb_flutter/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Database',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Colors.black,
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          modalBackgroundColor: Colors.black,
          backgroundColor: Colors.black,
        ),
        buttonColor: Colors.black12,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: Splash(),
    );
  }
}
