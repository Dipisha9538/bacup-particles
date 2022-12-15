import 'package:flutter/material.dart';

import '../../../Helpers/Colors.dart';
import '../../../Widgets/CustomText.dart';

class AddCreditCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: CustomText(
              text: 'Add Cards',
              color: primaryColor,
              fontWeight: FontWeight.w600),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Center(
        child: Text('test'),
      ),
    );
  }
}
