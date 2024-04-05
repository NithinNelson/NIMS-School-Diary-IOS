import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    {required BuildContext context, required String message, required Color color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat-Regular',
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.only(
        bottom: 50,
        right: 50,
        left: 50,
      ),
    ),
  );
}