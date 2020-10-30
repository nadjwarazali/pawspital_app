import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawspitalapp/models/weight.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/shared/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TargetWeight extends StatefulWidget {
  final Weight weights;

  TargetWeight({
    @required this.weights,
  });

  @override
  _TargetWeightState createState() => _TargetWeightState();
}

class _TargetWeightState extends State<TargetWeight> {



  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Container(
            height: 160,
            width: 350,
            child: StreamBuilder(
                stream: getUsersWeightStreamSnapshots(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('LOADING');
                  return calculateTargetWeight(
                      context, snapshot.data.documents[0]);
                }

                )));
  }

  Stream<QuerySnapshot> getUsersWeightStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('weight')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget calculateTargetWeight(BuildContext context, DocumentSnapshot weight) {
        double _weight = weight['weight'];
    double _targetWeight = (pow(_weight, 0.75)) * 70 * 1.2;
    double _reduceWeight = _targetWeight * 0.75;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            "Daily Calorie",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Countup(
                      begin: 0,
                      end: _targetWeight,
                      duration: Duration(seconds: 3),
                      separator: ',',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text('Target Weight'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 50,
                    child: VerticalDivider(
                      thickness: 3,
                      color: Color.fromRGBO(255, 205, 181, 1),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Countup(
                      begin: 0,
                      end: _reduceWeight,
                      duration: Duration(seconds: 3),
                      separator: ',',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text('Reduce Weight'),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
