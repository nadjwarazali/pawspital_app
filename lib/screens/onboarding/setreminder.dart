import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawspitalapp/screens/onboarding/setweight.dart';
import 'package:pawspitalapp/shared/button.dart';

class SetReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/ob1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          width: _width,
          height: _height,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height*0.7),
              Text(
                "Set Reminder for your Cat",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              CustomButton(
                text: 'Next',
                onPressed:(){ Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>SetWeight()));
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
