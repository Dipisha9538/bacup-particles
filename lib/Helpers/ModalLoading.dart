import 'package:flutter/material.dart';

import '../Widgets/CustomText.dart';
import 'Colors.dart';

void modalLoading(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white60,
    builder: (context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Container(
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: 'PASELL',
                  fontSize: 22,
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
              SizedBox(height: 20),
              Row(
                children: [
                  CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0)),
                  SizedBox(width: 10.0),
                  CustomText(text: message, fontSize: 18),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
