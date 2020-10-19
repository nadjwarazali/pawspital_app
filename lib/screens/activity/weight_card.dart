import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/weight.dart';
import 'package:pawspitalapp/screens/activity/weight_log.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeightCard extends StatefulWidget {
  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  final db = Firestore.instance;

  //Weight Log Initialize
  String weight;

  List<charts.Series<Weight, DateTime>> seriesList;
  List<Weight> myData;
  final _formkey = GlobalKey<FormState>();
  //Feed Log Initialize
  double percentage;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  var foodCal;

  _generateData(myData) {
    seriesList = List<charts.Series<Weight, DateTime>>();
    seriesList.add(charts.Series(
        domainFn: (Weight weight, _) => weight.timestamp,
        measureFn: (Weight weight, _) => int.parse(weight.weight),
        id: 'Weight',
        data: myData,
        labelAccessorFn: (Weight row, _) => "${row.weight}"));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: InkWell(
//        onTap: () => _addWeightBottomSheet(context),
        child: Container(
          height: 330,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Weight Log",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 190),
                  InkWell(
                    child: Icon(Icons.list),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeightLog()),
                      );
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: getUsersWeightStreamSnapshots(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  } else {
                    List<Weight> weight = snapshot.data.documents
                        .map((documentSnapshot) =>
                            Weight.fromMap(documentSnapshot.data))
                        .toList();
                    return _buildChart(context, weight);
                  }
                },
              ),
            ),
//            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text(
                  'Record',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _addWeightBottomSheet(context),
              ),
            ),
          ]),
        ),
      ),
    );
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

  _addWeightBottomSheet(BuildContext context) {
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
                  "Add Weight",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Form(
                    key: _formkey,
                    child: TextFormField(
                      decoration: inputTextDeco("Weight"),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Some Text";
                        }
                      },
                      onSaved: (value) => weight = value,
                    )),
                RaisedButton(
                  onPressed: _addWeight,
                  child: Text("Add"),
                ),
              ],
            ),
          );
        });
  }

  _addWeight() async {
    _formkey.currentState.save();
    final uid = await Provider.of(context).auth.getCurrentUID();
    await db
        .collection("userData")
        .document(uid)
        .collection("weight")
        .add({'weight': '$weight', 'timestamp': DateTime.now()});
    Navigator.of(context).pop();
  }

  Widget _buildChart(BuildContext context, List<Weight> weight) {
    myData = weight;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: charts.TimeSeriesChart(
              seriesList,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              animate: true,
              animationDuration: Duration(seconds: 2),
            ),
          ),
        ],
      )),
    );
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
