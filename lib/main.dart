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
      theme: ThemeData(
        splashColor: Color(0xFF1F2937),
        accentColor: Color(0xFF7C3AED),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1F2937),
        backgroundColor: Color(0xFF1F2937),
        cardColor: Color(0xFF374151),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(
            Colors.white,
          ),
          fillColor: MaterialStateProperty.all(
            Color(0xFF7C3AED),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7C3AED),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color(0xFF7C3AED),
            ),
          ),
        ),
        primaryColor: Color(0xFF7C3AED),
      ),
      home: Splash(),
    );
  }
}
