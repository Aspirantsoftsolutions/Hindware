import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  static void showMyToast(
      {String message, MessageType messagetype = MessageType.INFO}) {
    var color;
    switch (messagetype) {
      case MessageType.SUCCESS:
        {
          color = Color(0x951E3151);
          break;
        }
      case MessageType.INFO:
        {
          color = Color(0x95FEB743);
          break;
        }
      case MessageType.FAILURE:
        {
          color = Color(0x95EE1B24);
          break;
        }
      default:
        color = Color(0x951E3151);
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showMySnackBar(
      {BuildContext context,
      String message,
      MessageType messagetype = MessageType.INFO}) {
    var color;
    switch (messagetype) {
      case MessageType.SUCCESS:
        {
          color = Color(0x951E3151);
          break;
        }
      case MessageType.INFO:
        {
          color = Color(0x95FEB743);
          break;
        }
      case MessageType.FAILURE:
        {
          color = Color(0x95EE1B24);
          break;
        }
      default:
        color = Color(0x951E3151);
    }

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

enum MessageType { SUCCESS, FAILURE, INFO }
