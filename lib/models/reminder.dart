import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reminder{

  String reminderTitle;
  String location;
  String notes;
  String pet;
  String documentId;
  DateTime selectedDate;

  Reminder(
      this.reminderTitle,
      this.location,
      this.notes,
      this.pet,
      this.selectedDate
      );


  Map<String, dynamic> toJson() => {
    'reminderTitle': reminderTitle,
    'location' : location,
    'notes' : notes,
    'pet': pet,
    'selectedDate' : selectedDate
  };

  Reminder.fromSnapshot(DocumentSnapshot snapshot) :
     reminderTitle  = snapshot['reminderTitle'],
     location  = snapshot['location'],
     notes  = snapshot['notes'],
     pet  = snapshot['pet'],
     selectedDate = snapshot['selectedDate'],
     documentId = snapshot.documentID;

}
