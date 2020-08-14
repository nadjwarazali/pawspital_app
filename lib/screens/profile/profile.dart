import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/screens/pet/pet_register.dart';
import 'package:pawspitalapp/screens/pet/pet_view.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:flutter/cupertino.dart';

import 'edit_profile.dart';

class Profile extends StatelessWidget {
  //final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: 20.0,
                top: 30.0,
                bottom: 10.0,
              ),
              title: Text(
                'Hello!',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.compare_arrows,
                  color: Colors.black,
                ),
                onPressed: () async {
                Navigator.of(context).pushNamed("/convertUser");
              }),
            ],
            brightness: Brightness.light,
            expandedHeight: 90.0,
            floating: true,
            snap: true,
          ),

          //horizontal scroll list of pets
          StreamBuilder(
              stream: getUsersReminderStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: const Text(
                        "Start Adding reminder by clicking + on app bar"),
                  );
                return new SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) => buildReminderCard(
                            context, snapshot.data.documents[index]),
                        childCount: snapshot.data.documents.length));
              }),

            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Profile",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileView()),
                              );
                            }),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "My Pet",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PetView()),
                              );
                            }),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Devices",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                            onPressed: () {}),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromRGBO(220, 190, 181, 1),
                            textColor: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Logout",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              try {
                                AuthService auth = Provider.of(context).auth;
                                await auth.signOut();
                                print("Signed Out");
                              } catch (e) {
                                print(e);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ]));
  }

  Stream<QuerySnapshot> getUsersReminderStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('reminders')
        .orderBy('startDate')
        .snapshots();
  }

  Widget buildReminderCard(BuildContext context, DocumentSnapshot reminder) {
    return new Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        elevation: 6,
        child: InkWell(
          onTap: () {},
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


  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}
