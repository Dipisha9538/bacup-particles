import '../Views/Home/HomePage.dart';
import '../Widgets/AnimationRoute.dart';
import '../Widgets/CustomText.dart';
import '../Widgets/CustomButton.dart';
import 'package:flutter/material.dart';

void modalPayment(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white,
    builder: (context) {
      return AlertDialog(
        elevation: 0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 100, color: Colors.green),
            SizedBox(height: 10),
            CustomText(
              text: 'Successful Payment',
              fontSize: 19,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Continue',
              fontSize: 19,
              onPressed: () => Navigator.of(context).pushReplacement(
                  customRoute(page: HomePage(), curved: Curves.easeInOut)),
            )
          ],
        ),
      );
    },
  );
}
