import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        // toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}