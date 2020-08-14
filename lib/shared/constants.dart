import 'package:flutter/material.dart';

//const textInputDecoration = InputDecoration(
//      fillColor: Colors.white,
//      filled: true,
//      enabledBorder: OutlineInputBorder(
//          borderSide: BorderSide(color: Colors.white, width: 2.0)
//      ),
//      focusedBorder: OutlineInputBorder(
//          borderSide: BorderSide(color: Colors.pink, width: 2.0)
//      ),
//  );

InputDecoration textInputDecoration(String hint) {
      return InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
      );
}