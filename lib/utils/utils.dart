import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Utils{

  static final String imagePath = 'assets/images/';

  static Future<bool> isNetworkAvailable() async{
    //This creates the single instance by calling the `_internal` constructor specified below
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void showAlertDialog(BuildContext context, String msg,{Function()? onTap}) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK",
      textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.pop(context);
        if(onTap != null)
        onTap();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(msg,
        textAlign: TextAlign.center),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showUpdateAlertCallback(
      String title, String msg, String positiveButton,String negativeButton, void Function() onPositiveButtonClick, void Function() onNegativeButtonClick) {
    if (title.toLowerCase() == "error") {
      title = "Gods Aarti App";
    }
    Get.defaultDialog(
        barrierDismissible: false,
        title: "${title}",
        middleText: "${msg}",
        confirm: TextButton(
          child: Text(positiveButton),
          onPressed: () {
            onPositiveButtonClick();
            Get.back();
          },
        ),
        cancel: TextButton(
          child: Text(negativeButton),
          onPressed: () {
            onNegativeButtonClick();
            Get.back();
          },
        ),
        middleTextStyle:
        const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        titleStyle:
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500));
  }



}

