import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/weight.dart';
import 'package:pawspitalapp/screens/reminder/add_reminder.dart';
import 'package:pawspitalapp/models/reminder.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawspitalapp/services/provider_widget.dart';

class WeightLog extends StatefulWidget {
  final Weight weight;
  WeightLog({Key key, @required this.weight}) : super(key: key);

  @override
  _WeightState createState() => _WeightState();
}

class _WeightState extends State<WeightLog> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
              stream: getUsersWeightStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LinearProgressIndicator();
                return new ListView.builder(
                       itemBuilder: (BuildContext context, int index) => buildReminderCard(
                            context, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length);
              }),
      );
  }

  Stream<QuerySnapshot> getUsersWeightStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('weight').orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget buildReminderCard(BuildContext context, DocumentSnapshot weight) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
//        color: Color.fromRGBO(240, 188, 26, 0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                children: <Widget>[
              Text(
                weight['weight'].toString(),
                style: new TextStyle(fontSize: 23.0),
              ),
              Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () async {
                          await deleteWeight(weight);
                          Navigator.of(context).pop();
                        }),
                  ),
            ]),
            Text(
                dateFormat.format(weight['timestamp'].toDate())
            ),
              ]),
            ),
        );


  }

  Future deleteWeight(DocumentSnapshot weight) async {
    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("weight")
        .document(weight.documentID);
    return await doc.delete();
  }

}
