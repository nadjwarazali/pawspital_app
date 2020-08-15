import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/pet.dart';
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
    final newPet =
    new Pet(null, null, null, null);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0),
            child: Text(
              "Hello!",
              style: TextStyle(
                  color: Colors.black, fontSize: 50.0, fontWeight: FontWeight.bold),
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
        ),
      ),

      //horizontal scroll list of pets
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    color: Color.fromRGBO(240, 188, 26, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                        ),
                        SizedBox(width: 25),
                        Text(
                          "Add Pet",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetRegister(
                              pet: newPet,
                            )),
                      );
                    },
                  ),
                ),
//                SizedBox(width: 20.0),
                Expanded(
                  child: StreamBuilder(
                      stream: getUsersPetStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Container(child: Text("Loading"));

                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildPetCard(
                                    context, snapshot.data.documents[index]));
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 15, bottom: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        textColor: Colors.black,
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
                            MaterialPageRoute(
                                builder: (context) => ProfileView()),
                          );
                        }),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        textColor: Colors.black,
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
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        textColor: Colors.black,
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
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getUsersPetStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('pet')
        .snapshots();
  }

  Widget buildPetCard(BuildContext context, DocumentSnapshot pet) {
    return new Expanded(
//      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 150.0,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
//            margin: EdgeInsets.all(10),
                elevation: 5,
                child: InkWell(
                  onTap: () {},
//              child: Padding(
//                padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 43),
                              Icon(
                                Icons.pets,
                              ),
                              Text(
                                pet['petName'],
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      SizedBox(
                        width: 20.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
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
