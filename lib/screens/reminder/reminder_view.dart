import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/screens/reminder/add_reminder.dart';
import 'package:pawspitalapp/models/reminder.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'notification.dart';


class ReminderView extends StatefulWidget {
  final Reminder reminder;
  ReminderView({Key key, @required this.reminder}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<ReminderView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _petController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');


  @override
  Widget build(BuildContext context) {
    final newReminder =
        new Reminder(null, null, null, null, null);

    void _displayCardsDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewReminder(
                  reminder: newReminder,
                )),
      );
    }

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
                'Reminder',
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
                onPressed: () => _displayCardsDetail(),
              ),
              FlatButton(
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyApp2()),
                  );
                }
              ),
            ],
            brightness: Brightness.light,
            expandedHeight: 90.0,
            floating: true,
            snap: true,
          ),
          StreamBuilder(
              stream: getUsersReminderStreamSnapshots(context),
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

  Stream<QuerySnapshot> getUsersReminderStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('reminders').snapshots();
  }

  Widget buildReminderCard(BuildContext context, DocumentSnapshot reminder) {

    return new Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
        elevation: 5,
        child: InkWell(
          onTap: () {
            _displayReminderDetailsBottomSheet(context, reminder);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      reminder['reminderTitle'],
                      style: new TextStyle(fontSize: 23.0),
                    ),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: Row(children: <Widget>[
                    Text(
                    dateFormat.format(reminder['selectedDate'].toDate())
                    ),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      reminder['pet'],
                      style: new TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.brown),
                    ),
                    Spacer(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _displayReminderDetailsBottomSheet(
      BuildContext context, DocumentSnapshot reminderData) {
    print(reminderData.documentID);
    print(reminderData['selectedDate']);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30.0),
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Details ",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Reminder: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          reminderData['reminderTitle'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Location: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          reminderData['location'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Notes: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          reminderData['notes'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Assigned Pet: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          reminderData['pet'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            onPressed: () {
                              _editReminderBottomSheet(context, reminderData);
//                              Navigator.of(context).pop();
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => EditReminder(reminder: widget.reminder)));
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            onPressed: () async {
                              await deleteReminder(reminderData);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home', (Route<dynamic> route) => false);
//                              Navigator.of(context).pop();
                            }),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          );
        });
  }

  void _editReminderBottomSheet(
      BuildContext context, DocumentSnapshot reminderData) {
    _titleController.text = reminderData['reminderTitle'];
    _locationController.text = reminderData['location'];
    _notesController.text = reminderData['notes'];
    _petController.text = reminderData['pet'];

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: inputTextDeco("Reminder"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    controller: _locationController,
                    decoration: inputTextDeco("Location"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Container(
                    child: TextField(
                      controller: _notesController,
                      decoration: inputTextDeco("Notes"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    controller: _petController,
                    decoration: inputTextDeco("Pet Name"),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                RaisedButton(
                  child: Text(
                    "submit",
                  ),
                  color: Colors.lightGreen,
                  onPressed: () async {
                    await updateReminder(context, reminderData);
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Future updateReminder(
      BuildContext context, DocumentSnapshot reminderData) async {

    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("reminders")
        .document(reminderData.documentID);
    return await doc
        .updateData({
          'reminderTitle': _titleController.text,
          'location': _locationController.text,
          'notes': _notesController.text,
          'pet': _petController.text
        })
        .then((value) => _titleController.clear())
        .then((value) => _locationController.clear())
        .then((value) => _notesController.clear())
        .then((value) => _petController.clear());
  }

  Future deleteReminder(DocumentSnapshot reminderData) async {
    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("reminders")
        .document(reminderData.documentID);
    return await doc.delete();
  }

  InputDecoration inputTextDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }
}
