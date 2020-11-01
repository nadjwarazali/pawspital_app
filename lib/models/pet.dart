import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  class Pet {
    String petName;
    String breed;
    String birthday;
    String documentId;

    Pet(
        this.petName,
        this.breed,
        this.birthday,
        );


    Map<String, dynamic> toJson() => {
      'petName': petName,
      'breed': breed,
      'birthday': birthday,
    };


  Pet.fromSnapshot(DocumentSnapshot snapshot) :
        petName  = snapshot['petName'],
        breed  = snapshot['breed'],
        birthday  = snapshot['birthday'],
        documentId = snapshot.documentID;

}