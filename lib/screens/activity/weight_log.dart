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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: 20.0,
                top: 30.0,
                bottom: 10.0,
              ),
              title: Text(
                'Weight Log',
                style: TextStyle(color:Colors.black , fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
//                onPressed: () => _displayCardsDetail(),
              )
            ],
            brightness: Brightness.light,
            expandedHeight: 90.0,
            floating: true,
            snap: true,
          ),
          StreamBuilder(
              stream: getUsersWeightStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(),
                  );
                return new SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) => buildReminderCard(
                            context, snapshot.data.documents[index]),
                        childCount: snapshot.data.documents.length));
              }),
        ],
      ),
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
    return new Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
//        color: Color.fromRGBO(240, 188, 26, 0),
        elevation: 1,
        child: InkWell(
          onTap: () {
//            _displayReminderDetailsBottomSheet(context, reminder);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      weight['weight'],
                      style: new TextStyle(fontSize: 23.0),
                    ),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: Row(children: <Widget>[
                    Text(
                        dateFormat.format(weight['timestamp'].toDate())
                    ),
                    Spacer(),
                  ]),
                ),
                  ]),
                ),
            ),
          ),
        );
  }

}
