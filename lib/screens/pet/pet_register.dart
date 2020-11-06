import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/pet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/shared/textField.dart';

class PetRegister extends StatefulWidget {
  final Pet pet;
  PetRegister({Key key, @required this.pet}) : super(key: key);

  @override
  _PetRegisterState createState() => _PetRegisterState();
}

class _PetRegisterState extends State<PetRegister> {
  final db = Firestore.instance;
  TextEditingController _petNameController = new TextEditingController();
  TextEditingController _breedController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();

  @override
  void initState() {
   _breedController.clear();
   _petNameController.clear();
   _birthdayController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    _petNameController.text = widget.pet.petName;
    _breedController.text = widget.pet.breed;
    _birthdayController.text = widget.pet.birthday;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background2.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          width: _width,
          height: _height,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                AppBar(
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        size: 20, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text("Add Pet", style: TextStyle(color: Colors.black)),
                  centerTitle: true,
                ),
                SizedBox(
                  height: 250,
                ),
                CustomTextField(
                  controller: _petNameController,
                  decoration:
                      locator.get<InputTextDeco>().inputTextDeco("Pet Name"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextField(
                  controller: _breedController,
                  decoration:
                      locator.get<InputTextDeco>().inputTextDeco("Breed"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextField(
                  controller: _birthdayController,
                  decoration:
                      locator.get<InputTextDeco>().inputTextDeco("Birthday"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomButton(
                  text: 'save',
                  onPressed: () async {
                    widget.pet.petName = _petNameController.text;
                    widget.pet.breed = _breedController.text;
                    widget.pet.birthday = _birthdayController.text;

                    final uid = await Provider.of(context).auth.getCurrentUID();
                    await db
                        .collection("userData")
                        .document(uid)
                        .collection("pet")
                        .add(widget.pet.toJson());

//                    return to homepage
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
