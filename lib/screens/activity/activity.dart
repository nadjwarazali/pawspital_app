import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/weight.dart';
import 'file:///D:/Android/Project/New/pawspital_app/lib/screens/activity/weight/target_weight.dart';
import 'file:///D:/Android/Project/New/pawspital_app/lib/screens/activity/weight/weight_card.dart';
import 'bluetooth_device.dart';
import 'feed/food_card.dart';
import 'dart:ui';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        width: _width,
        height: _height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0),
              AppBar(
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 20.0),
                  child: Text(
                    "Activity",
                    style: TextStyle(
                        color: Color.fromRGBO(59, 48, 71, 1),
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                elevation: 0.0,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // Container(
                      //   height: 100,
                      //   child: _cardBluetooth(),
                      // ),
                      WeightCard(),
                      TargetWeight(),
                      FoodCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _cardBluetooth() {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     margin: EdgeInsets.all(10),
  //     elevation: 4,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => FlutterBlueApp()),
  //         );
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: <Widget>[
  //                 Icon(
  //                   Icons.devices,
  //                 ),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   "Devices",
  //                   style:
  //                       TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
  //                 ),
  //                 Spacer(),
  //               ],
  //             ),
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }
}
