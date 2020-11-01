import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Food{
  double foodCal;

  Food(
      this.foodCal,
      );


  Map<String, dynamic> toJson() => {
    'foodCal': foodCal,
  };

  Food.fromSnapshot(DocumentSnapshot snapshot) :
        foodCal  = snapshot['foodCal'];
}
