import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  class Pet {
    String petName;
    String breed;
    String birthday;
    String weight;
    String documentId;

    Pet(
        this.petName,
        this.breed,
        this.birthday,
        this.weight,
        );


    Map<String, dynamic> toJson() => {
      'petName': petName,
      'breed': breed,
      'birthday': birthday,
      'weight': weight,
    };


  Pet.fromSnapshot(DocumentSnapshot snapshot) :
        petName  = snapshot['petName'],
        breed  = snapshot['breed'],
        birthday  = snapshot['birthday'],
        weight  = snapshot['weight'],
        documentId = snapshot.documentID;

}