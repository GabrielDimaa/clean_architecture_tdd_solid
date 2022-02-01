import 'package:flutter/material.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final primaryColor = const Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = const Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = const Color.fromRGBO(188, 71, 123, 1);
  final secondaryColor = const Color.fromRGBO(0, 77, 64, 1);
  final secondaryColorDark = const Color.fromRGBO(0, 37, 26, 1);
  final disabledColor = Colors.grey[400];
  final dividerColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "4Dev",
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        highlightColor: secondaryColor,
        secondaryHeaderColor: secondaryColorDark,
        disabledColor: disabledColor,
        dividerColor: dividerColor,
        colorScheme: ColorScheme.light(primary: primaryColor),
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorLight)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          alignLabelWithHint: true,
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(primary: primaryColor),
          buttonColor: primaryColor,
          splashColor: primaryColorLight,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
