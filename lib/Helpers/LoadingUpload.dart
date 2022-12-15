import 'Colors.dart';
import '../Widgets/CustomText.dart';
import 'package:flutter/material.dart';

void loadinUploadFile(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Color.fromARGB(137, 218, 22, 22),
    builder: (context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: CustomText(
          text: 'Uploading Image',
          color: primaryColor,
        ),
        content: Container(
          height: 200,
          width: 350,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 3),
            builder: (context, value, child) {
              int percent = (value * 100).ceil();
              return Container(
                width: 230,
                height: 230,
                //  color: Colors.yellow,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2,
                                  stops: [value, value],
                                  center: Alignment.center,
                                  colors: [primaryColor, Colors.transparent])
                              .createShader(rect);
                        },
                        child: Container(
                          height: 230,
                          width: 230,
                          decoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                            child: CustomText(
                          text: '$percent %',
                          fontSize: 40,
                        )),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
