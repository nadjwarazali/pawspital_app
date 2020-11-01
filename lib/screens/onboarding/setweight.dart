import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/navigation.dart';
import 'package:pawspitalapp/screens/onboarding/setfood.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';

class SetWeight extends StatefulWidget {
  @override
  _SetWeightState createState() => _SetWeightState();
}

class _SetWeightState extends State<SetWeight> {
  final db = Firestore.instance;
  final _secondaryColor = Color.fromRGBO(172, 119, 119, 1);
  double weight;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/ob2.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          width: _width,
          height: _height,
          child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
//              mainAxisAlignment: ,
                    children: <Widget>[
                      SizedBox(height: _height*0.62),
                      Text(
                        "Track your Cat's Weight",
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Form(
                            key: _formkey,
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
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomButton(
                        text: 'Add',
                        onPressed: _addWeight,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 300),
                //   child: FlatButton(
                //     child: Row(
                //       children: <Widget>[
                //         Text('Next',
                //         style: TextStyle(
                //           color: Color.fromRGBO(64, 51, 84, 1),
                //           fontSize: 17
                //         ),),
                //         Icon(
                //             Icons.navigate_next
                //           ),
                //     ]),
                //     onPressed: () {
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>Home()));
                // }
                //   ),
                // )
              ]),
        ),
      ),
    );
  }

  _addWeight() async {
    _formkey.currentState.save();
    final uid = await Provider.of(context).auth.getCurrentUID();
    await db
        .collection("userData")
        .document(uid)
        .collection("weight")
        .add({'weight': double.parse('$weight'), 'timestamp': DateTime.now()});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>SetFood()));
  }
}
