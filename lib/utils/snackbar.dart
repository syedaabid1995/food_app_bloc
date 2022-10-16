import 'package:flutter/material.dart';
import 'package:food_app/constants/colors.dart';


void snackBar(BuildContext context, String message, {bool isSuccess = false}) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        duration: Duration(milliseconds: 800),
        backgroundColor: (isSuccess == true) ? lightGreenColor : redColor,
        content: Container(
          child: Text(
            message,
            style: TextStyle(color: whiteColor),
          ),
        )),
  );
}
