import 'package:flutter/material.dart';

class InputTextDeco{
      InputDecoration inputTextDeco(String hint) {
            return InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 0.2)),
                  contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
            );
      }
}

