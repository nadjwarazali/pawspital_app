import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Weight {
  double weight;
  DateTime timestamp;
  String documentId;

  Weight(this.weight, this.timestamp);

  Weight.fromSnapshot(DocumentSnapshot snapshot)
      : weight = snapshot.data['weight'],
        timestamp = snapshot.data['timestamp'],
        documentId = snapshot.documentID;

  Weight.fromMap(Map<String, dynamic> map)
      : assert(map['weight'] != null),
        assert(map['timestamp'] != null),
        weight = map['weight'],
        timestamp = map['timestamp'].toDate();

  @override
  String toString() => "Record<$weight: $timestamp>";
}
