import 'package:flutter/material.dart';
import 'package:pawspitalapp/screens/activity/weight_card.dart';
import 'bluetooth_device.dart';
import 'food_card.dart';
import 'dart:ui';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0),
            child: Text(
              "Activity",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  child: _cardBluetooth(),
                ),
                WeightCard(),
                FoodCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cardBluetooth() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FlutterBlueApp()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.devices,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Devices",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
