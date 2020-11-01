import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final _secondaryColor = Color.fromRGBO(64, 51, 84, 1);
    return RaisedButton(
      color: _secondaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}


