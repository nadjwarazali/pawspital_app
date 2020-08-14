import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/pet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawspitalapp/services/provider_widget.dart';



class PetRegister extends StatefulWidget {
  final Pet pet;
  PetRegister({Key key, @required this.pet}) : super(key: key);

  @override
  _PetRegisterState createState() => _PetRegisterState();
}

class _PetRegisterState extends State<PetRegister> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController _petNameController = new TextEditingController();
    _petNameController.text = widget.pet.petName;
    TextEditingController _breedController = new TextEditingController();
    _breedController.text = widget.pet.breed;
    TextEditingController _birthdayController = new TextEditingController();
    _birthdayController.text = widget.pet.birthday;
    TextEditingController _weightController = new TextEditingController();
    _weightController.text = widget.pet.weight;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Pet"),
        backgroundColor: Color.fromRGBO(220, 190, 181, 1),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
                child: TextField(
                  controller: _birthdayController,
                  decoration: inputTextDeco("Birthday"),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _weightController,
                  decoration: inputTextDeco("Weight"),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () async {
                  widget.pet.petName = _petNameController.text;
                  widget.pet.breed = _breedController.text;
                  widget.pet.birthday = _birthdayController.text;
                  widget.pet.weight = _weightController.text;

                  final uid = await Provider.of(context).auth.getCurrentUID();
                  await db.collection("userData").document(uid).collection("pet").add(widget.pet.toJson());

//                    return to homepage
                  Navigator.of(context).pop();


                },
              )
            ],
          ),
        ),
      ),
    );
  }
  InputDecoration inputTextDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
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


