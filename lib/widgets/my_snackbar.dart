import 'package:flutter/material.dart';

class MySnackbar {
  static void showSnackbar(BuildContext context, String message,
      {Color backgroundColor = Colors.black, Color textColor = Colors.white, int durationInSeconds = 3}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
