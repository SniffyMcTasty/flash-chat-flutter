import 'package:flutter/material.dart';

import '../constants.dart';

class CredentialsTextField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Color borderSide;
  final bool obscureText;
  final TextInputType? keyboardType;

  CredentialsTextField(
      {this.hintText = '',
      this.onChanged,
      this.borderSide = Colors.blue,
      this.obscureText = false,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black),
      cursorColor: borderSide,
      obscureText: obscureText,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
            vertical: fScreenHeight(context) * 0.015, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderSide, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderSide, width: 4.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
