import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawspitalapp/models/pet.dart';
import 'package:pawspitalapp/screens/pet/pet_register.dart';
import 'package:pawspitalapp/services/provider_widget.dart';


class PetView extends StatefulWidget {
  final Pet pet;
  PetView({this.pet});

  @override
  _PetState createState() => _PetState();
}

class _PetState extends State<PetView> {
  TextEditingController _petNameController = new TextEditingController();
  TextEditingController _breedController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newPet =
    new Pet(null, null, null, null);

    void _displayCardsDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PetRegister(
              pet: newPet,
            )),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: 20.0,
                top: 30.0,
                bottom: 10.0,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'My Pet',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            backgroundColor: Color.fromRGBO(220, 190, 181, 1),
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => _displayCardsDetail(),
              ),
            ],
            brightness: Brightness.light,
            expandedHeight: 90.0,
            floating: true,
            snap: true,
          ),
          StreamBuilder(
              stream: getUsersPetStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: const Text(
                        "Loading"),
                  );
                return new SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) => buildPetCard(
                            context, snapshot.data.documents[index]),
                        childCount: snapshot.data.documents.length));
              }),
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
    return new Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: InkWell(
          onTap: () {
            _displayPetDetailsBottomSheet(context, pet);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      pet['petName'],
                      style: new TextStyle(fontSize: 23.0),
                    ),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text(
                      pet['breed'],
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

  void _displayPetDetailsBottomSheet(
      BuildContext context, DocumentSnapshot petData) {
    print(petData.documentID);
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
                        Text("PetName: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          petData['petName'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Breed: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          petData['breed'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Birthday: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          petData['birthday'],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Weight: ",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300)),
                        Text(
                          petData['weight'],
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
                              _editPetBottomSheet(context, petData);
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
                              await deletePet(petData);
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

  void _editPetBottomSheet(
      BuildContext context, DocumentSnapshot petData) {
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

  Future updatePet(
      BuildContext context, DocumentSnapshot petData) async {

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
