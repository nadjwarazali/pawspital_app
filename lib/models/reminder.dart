import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reminder{

  String reminderTitle;
  String location;
  String notes;
  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  String pet;
  String documentId;

  Reminder(
      this.reminderTitle,
      this.location,
      this.notes,
      this.startDate,
      this.startTime,
      this.endDate,
      this.pet
      );


  Map<String, dynamic> toJson() => {
    'reminderTitle': reminderTitle,
    'location' : location,
    'notes' : notes,
    'startDate': startDate,
    'startTime': startTime,
    'endDate': endDate,
    'pet': pet,
  };

  Reminder.fromSnapshot(DocumentSnapshot snapshot) :
     reminderTitle  = snapshot['reminderTitle'],
     location  = snapshot['location'],
     notes  = snapshot['notes'],
     startDate  = snapshot['startDate'],
     startTime  = snapshot['startTime'],
     endDate = snapshot['endDate'],
     pet  = snapshot['pet'],
     documentId = snapshot.documentID;

}