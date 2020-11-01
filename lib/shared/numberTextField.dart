import 'package:flutter/material.dart';

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;

  const NumberTextField({this.controller, this.decoration});

  @override
  Widget build(BuildContext context) {
    final _secondaryColor = Color.fromRGBO(172, 119, 119, 1);
    return Material(
      borderRadius: BorderRadiusDirectional.circular(20),
      elevation: 3,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: decoration,
        cursorColor: _secondaryColor,
      ),
    );
  }
}


