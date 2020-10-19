import 'dart:ui';
import 'painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/services/provider_widget.dart';

class FoodCard extends StatefulWidget {
  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with TickerProviderStateMixin {
  final db = Firestore.instance;
  //Feed Log Initialize
  double percentage;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  var foodCal;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      percentage = 0.0;
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
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Container(
            height: 300,
            width: 350,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Feed Log",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 200),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                      ),
                      onTap: () => _addFoodBottomSheet(context),
                    )
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
                        completeColor: Colors.amber,
                        completePercent: percentage,
                        width: 20.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text(
                      'Feed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        percentage = newPercentage;
                        newPercentage += 33.33;
                        if (newPercentage > 100.0) {
                          percentage = 0.0;
                          newPercentage = 0.0;
                        }
                        percentageAnimationController.forward(from: 0.0);
                      });
                    }),
              ),
              StreamBuilder(
                  stream: getFoodCal(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text('Please Add Food Calories Value');
                    return Text(snapshot.data.documents[0]['foodcalories']);
                  })
            ])));
  }

  _addFoodBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 30.0),
            child: Column(
//              mainAxisAlignment: ,
              children: <Widget>[
                Text(
                  "Food",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: inputTextDeco("Calorie per Serving"),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter Some Text";
                            }
                          },
                          onSaved: (value) => foodCal = value,
                        ),
                      ],
                    )),
                RaisedButton(
                  onPressed: _addFood,
                  child: Text("Add"),
                ),
              ],
            ),
          );
        });
  }

  _addFood() async {
    _formkey.currentState.save();
    final uid = await Provider.of(context).auth.getCurrentUID();
    await db
        .collection("userData")
        .document(uid)
        .collection("food")
        .document("calories")
        .setData({
      'foodcalories': '$foodCal',
    });
    Navigator.of(context).pop();
  }

  Stream<QuerySnapshot> getFoodCal(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('food')
        .snapshots();
  }

  InputDecoration inputTextDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }
}
