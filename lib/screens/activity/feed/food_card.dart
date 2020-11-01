import 'dart:ui';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/shared/numberTextField.dart';

import 'painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/models/food.dart';

class FoodCard extends StatefulWidget {
  final Food food;
  FoodCard({@required this.food});

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with TickerProviderStateMixin {
  TextEditingController _foodCalController = TextEditingController();
  final db = Firestore.instance;
  //Feed Log Initialize
  double percentage;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  double _foodCalVal;
  double newFoodVal;

  @override
  void initState() {
    super.initState();
    // _foodCalVal = (widget.food.foodCal ?? 0.0).floor();

    setState(() {
      percentage = 0.0;
      newFoodVal = 0;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    // _foodCalController.text = widget.food.foodCal.toString();
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Container(
            height: 300,
            width: 350,
            child: Column(
              children: <Widget>[
                StreamBuilder(
                    stream: getFoodCal(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return buildFoodCard(context, snapshot.data.documents[0]);
                    }),
              ],
            )));
  }

  Future setFoodCal(BuildContext context, DocumentSnapshot foodData) async {
    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("food")
        .document("calories");

    return await doc.updateData({
      'foodCal': double.parse(_foodCalController.text),
    }).then((value) => _foodCalController.clear());
  }

  Widget buildFoodCard(BuildContext context, DocumentSnapshot foodData) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Text(
                "Feed Log",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 200),
              InkWell(
                child: Icon(
                  Icons.settings,
                ),
                onTap: () => _addFoodBottomSheet(context, foodData),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100.0,
            width: 100.0,
            child: new CustomPaint(
              foregroundPainter: new MyPainter(
                  lineColor: Colors.white,
                  completeColor: Color.fromRGBO(255, 205, 181, 1),
                  completePercent: percentage,
                  width: 20.0),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new CustomButton(
              text: 'Feed',
              onPressed: () {
                setState(() {
                  percentage = newPercentage;
                  newPercentage += 33.33;

                  _foodCalVal = foodData['foodCal'];
                  newFoodVal = newFoodVal + _foodCalVal;

                  if (newPercentage > 100.0) {
                    percentage = 0.0;
                    newPercentage = 0.0;
                    newFoodVal = 0;
                  }
                  percentageAnimationController.forward(from: 0.0);

                  print(newFoodVal);
                });
              }),
        ),
        Text(
          newFoodVal.toString() + "kcal",
        ),
      ],
    );
  }

  _addFoodBottomSheet(BuildContext context, DocumentSnapshot foodData) {
    _foodCalController.text = foodData['foodCal'];

    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
//              mainAxisAlignment: ,
                  children: <Widget>[
                    Text(
                      "Add Calorie Value",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Material(
                        borderRadius: BorderRadiusDirectional.circular(20),
                        elevation: 3,
                        child: NumberTextField(
                          controller: _foodCalController,
                          decoration: locator
                              .get<InputTextDeco>()
                              .inputTextDeco("Calorie per serving"),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: 'Add',
                      onPressed: () async {
                        await setFoodCal(context, foodData);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Stream<QuerySnapshot> getFoodCal(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('food')
        .snapshots();
  }
}
