import 'package:animate_do/animate_do.dart';
import 'BaseServerUrl.dart';
import 'Colors.dart';
import '../Widgets/CustomText.dart';
import 'package:flutter/material.dart';

void modalAddCartSuccess(BuildContext context, String image) {
  showDialog(
    context: context,
    barrierColor: Colors.white60,
    builder: (context) {
      return BounceInDown(
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            height: 130,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      publicServerUrl + image,
                      height: 80.0,
                    ),
                    SizedBox(width: 10.0),
                    BounceInLeft(
                        child: Icon(Icons.check_circle_outlined,
                            color: Colors.green, size: 80)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
