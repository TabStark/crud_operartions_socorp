import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class customflushbar {
  static void showFlushBar(BuildContext context, String msg) {
    Flushbar(
      backgroundColor: Colors.black,
      message: msg,
      messageColor: Colors.white,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}