import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/screens/activity/weight_log.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'bluetooth_device.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  String weight;
  final db = Firestore.instance;
  final _formkey = GlobalKey<FormState>();
  List<charts.Series<Weight, DateTime>> seriesList;
  List<Weight> myData;

  _generateData(myData) {
    seriesList = List<charts.Series<Weight, DateTime>>();
    seriesList.add(charts.Series(
        domainFn: (Weight weight, _) => weight.timestamp,
        measureFn: (Weight weight, _) => int.parse(weight.weight),
        id: 'Weight',
        data: myData,
        labelAccessorFn: (Weight row, _) => "${row.weight}"
        ));
  }

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
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: _cardBluetooth(),
              ),
              Container(
                child: _cardWeightLog(context),
              ),
            ],
          ),
        ),
      ),
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
                  style: TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.w500),
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
        .add({'weight': '$weight', 'timestamp': FieldValue.serverTimestamp()});
    db
        .collection("userData")
        .document(uid)
        .collection("weight")
        .orderBy('timestamp', descending: true)
        .snapshots();

    Navigator.of(context).pop();
  }

  Widget _buildChart(BuildContext context, List<Weight> weight) {
    myData = weight;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          child: Expanded(
        child: charts.TimeSeriesChart(
          seriesList,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          animate: true,
          animationDuration: Duration(seconds: 2),
        ),
      )),
    );
  }

  Stream<QuerySnapshot> getUsersWeightStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('weight')
        .snapshots();
  }

  _cardBluetooth() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(10),
      elevation: 6,
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
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
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

  _cardWeightLog(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(10),
      elevation: 6,
      child: InkWell(
//        onTap: () => _addWeightBottomSheet(context),
        child: Container(
          height: 330,
          child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                        Icons.show_chart,
                      ),
                        SizedBox(width: 10),
                        Text(
                          "Weight Log",
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: getUsersWeightStreamSnapshots(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Try Again");
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
                child: Text("Record"),
                onPressed: () => _addWeightBottomSheet(context),
              ),
            ),
            ]),
          ),
        ),
      );
  }
}
