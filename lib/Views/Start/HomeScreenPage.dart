import 'package:flutter/material.dart';

import '../../Widgets/CustomButton.dart';
import '../../Widgets/CustomText.dart';

class HomeScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 73, 223),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CustomText(
                              text: 'Pa',
                              fontSize: 20,
                              color: Color.fromARGB(255, 248, 248, 250),
                            ),
                          ),
                          CustomText(
                              text: 'Sell',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 248, 248, 249)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      CustomButton(
                          text: 'Get Started',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1C2834),
                          textColor: Color.fromARGB(255, 244, 239, 239),
                          onPressed: () => Navigator.of(context)
                              .pushNamed('HomeScreenPageee')),
                      SizedBox(height: 30.0),
                      // CustomButton(
                      //   text: 'Sign In',
                      //   fontWeight: FontWeight.bold,
                      //   color: Color.fromARGB(255, 242, 239, 239),
                      //   textColor: Color.fromARGB(255, 253, 250, 250),
                      //   onPressed: () =>
                      //       Navigator.of(context).pushNamed('signInPage'),
                      // ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
