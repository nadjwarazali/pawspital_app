import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/weight.dart';
import 'file:///D:/Android/Project/New/pawspital_app/lib/screens/activity/weight/weight_log.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';

class WeightCard extends StatefulWidget {
  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  final db = Firestore.instance;
  final _secondaryColor = Color.fromRGBO(172, 119, 119, 1);
  //Weight Log Initialize
  double weight;

  List<charts.Series<Weight, DateTime>> seriesList;
  List<Weight> myData;
  final _formkey = GlobalKey<FormState>();

  _generateData(myData) {
    seriesList = List<charts.Series<Weight, DateTime>>();
    seriesList.add(charts.Series(
        seriesColor: charts.ColorUtil.fromDartColor(Color.fromRGBO(172, 119, 119, 1)),
        domainFn: (Weight weight, _) => weight.timestamp,
        measureFn: (Weight weight, _) => (weight.weight),
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
            child: CustomButton(
              text: 'Record',
              onPressed: () => _addWeightBottomSheet(context),
            ),
          ),
        ]),
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
                    "Add Weight",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          elevation: 3,
                          child: TextFormField(
                            decoration: locator.get<InputTextDeco>().inputTextDeco("Weight"),
                            keyboardType: TextInputType.number,
                            cursorColor: _secondaryColor,
                            validator: (value) {
                              // ignore: missing_return
                              if (value.isEmpty)
                                return 'add some value';
                            },
                            onSaved: (value) => weight = double.parse(value),
                          ),
                        ),
                      )),
                  CustomButton(
                    text: 'Add',
                    onPressed: _addWeight,
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ]);
        });
  }

  _addWeight() async {
    _formkey.currentState.save();
    final uid = await Provider.of(context).auth.getCurrentUID();
    await db
        .collection("userData")
        .document(uid)
        .collection("weight")
        .add({'weight': double.parse('$weight'), 'timestamp': DateTime.now()});
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

}
