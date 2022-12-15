import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFrave extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final IconData prefixIcon;
  final TextInputType type;
  final Color focusBorderColor;
  final bool obscureText;
  final TextEditingController controller;
  final Function validator;
  final double fontSize;
  final bool isIcon;
  final bool isSuffixIcon;
  final IconData suffixIcon;
  final Function onPressedSuffixIcon;

  const TextFormFrave(
      {this.hintText,
      this.fillColor = const Color(0xffF5F5F5),
      this.prefixIcon,
      this.type,
      this.focusBorderColor = const Color(0xff1E4DD8),
      this.obscureText = false,
      this.controller,
      this.validator,
      this.fontSize = 17,
      this.isIcon = true,
      this.isSuffixIcon = false,
      this.suffixIcon,
      this.onPressedSuffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: obscureText,
        validator: validator,
        cursorHeight: 25,
        style: GoogleFonts.getFont('Roboto', fontSize: fontSize),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
          filled: true,
          fillColor: fillColor,
          hintText: hintText,
          hintStyle: GoogleFonts.getFont('Roboto', color: Color(0xffB4B9C0)),
          prefixIcon: isIcon
              ? Icon(prefixIcon, color: Color.fromARGB(255, 63, 62, 62))
              : null,
          suffixIcon: isSuffixIcon
              ? IconButton(
                  icon: Icon(suffixIcon),
                  color: Color.fromARGB(255, 14, 14, 14),
                  onPressed: onPressedSuffixIcon,
                  splashColor: Colors.transparent)
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 21, 21, 21))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 22, 22, 22))),
          // focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
