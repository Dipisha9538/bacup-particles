import 'package:flutter/material.dart';

import 'CustomText.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final double height;
  final double width;
  final double borderRadius;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final Function onPressed;

  const CustomButton(
      {@required this.text,
      this.color = Colors.white,
      this.height = 100,
      this.width = 110,
      this.borderRadius = 8.0,
      this.textColor = Colors.white,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 18,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 130,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 6, 54, 117),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
        child: CustomText(
          text: text,
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
