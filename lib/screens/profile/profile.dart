import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/pet.dart';
import 'package:pawspitalapp/screens/pet/pet_register.dart';
import 'package:pawspitalapp/screens/pet/pet_view.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:flutter/cupertino.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  //final primaryColor = const Color(0xFF75A2EA);
  final Pet pet;
  Profile({this.pet});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _petNameController = new TextEditingController();
  TextEditingController _breedController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newPet = new Pet(null, null, null, null);

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
                  color: Colors.black,
                  fontSize: 45.0,
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
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 55,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 30),
                    child: Icon(
                      Icons.account_circle,
                      size: 60.0,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      FutureBuilder(
                        future: Provider.of(context).auth.getCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return displayUserInformation(context, snapshot);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                //Add Pet Button
                Container(
                  width: 140.0,
                  height: 140.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    color: Color.fromRGBO(240, 188, 26, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                        ),
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
                SizedBox(width: 7),
                //Pet List
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
          //Utilities Buttons
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
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
                  SizedBox(height: 17),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.devices,
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
                  SizedBox(height: 17),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
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
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 150.0,
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    _displayPetDetailsBottomSheet(context, pet);
                  },
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 43),
                              Icon(
                                Icons.pets,
                                color: Colors.white,
                              ),
                              Text(
                                pet['petName'],
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
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

  void _displayPetDetailsBottomSheet(
      BuildContext context, DocumentSnapshot petData) {
    print(petData.documentID);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Details ",
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 160),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            _editPetBottomSheet(context, petData);
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await deletePet(petData);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home', (Route<dynamic> route) => false);
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Pet Name: ",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w300)),
                            Text(
                              petData['petName'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 15),
                            Text("Breed: ",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w300)),
                            Text(
                              petData['breed'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 15),
                            Text("Birthday: ",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w300)),
                            Text(
                              petData['birthday'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 15),
                            Text("Weight: ",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w300)),
                            Text(
                              petData['weight'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        });
  }

  void _editPetBottomSheet(BuildContext context, DocumentSnapshot petData) {
    _petNameController.text = petData['petName'];
    _breedController.text = petData['breed'];
    _weightController.text = petData['weight'];
    _birthdayController.text = petData['birthday'];

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
                    controller: _petNameController,
                    decoration: inputTextDeco("Pet Name"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    controller: _breedController,
                    decoration: inputTextDeco("Breed"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Container(
                    child: TextField(
                      controller: _weightController,
                      decoration: inputTextDeco("Weight"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    controller: _birthdayController,
                    decoration: inputTextDeco("Birthday"),
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
                    await updatePet(context, petData);
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Future updatePet(BuildContext context, DocumentSnapshot petData) async {
    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("pet")
        .document(petData.documentID);
    return await doc
        .updateData({
          'petName': _petNameController.text,
          'breed': _breedController.text,
          'weight': _weightController.text,
          'birthday': _birthdayController.text
        })
        .then((value) => _petNameController.clear())
        .then((value) => _breedController.clear())
        .then((value) => _weightController.clear())
        .then((value) => _birthdayController.clear());
  }

  Future deletePet(DocumentSnapshot petData) async {
    var uid = await Provider.of(context).auth.getCurrentUID();
    final doc = Firestore.instance
        .collection("userData")
        .document(uid)
        .collection("pet")
        .document(petData.documentID);
    return await doc.delete();
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

Widget displayUserInformation(context, snapshot) {
  final authData = snapshot.data;
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${authData.displayName ?? 'Anonymous'}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "${authData.email ?? 'Anonymous'}",
          style: TextStyle(fontSize: 15),
        ),
      ],
    ),
  );
}
