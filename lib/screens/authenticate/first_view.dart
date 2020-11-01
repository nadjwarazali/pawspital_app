import 'package:flutter/material.dart';
//import 'package:auto_size_text/auto_size_text.dart';
import 'package:pawspitalapp/services/custom_dialog.dart';
import 'package:pawspitalapp/shared/button.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color.fromRGBO(64, 51, 84, 1);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: _width,
        height: _height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
             SizedBox(height: _height*0.67),
                RaisedButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Get Started',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,

                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Create new account?",
                        description:
                            "A new way of showing love to your pet pal! Register account now",
                        primaryButtonText: "Create My Account",
                        primaryButtonRoute: "/signUp",
                        secondaryButtonText: "Sign In",
                        secondaryButtonRoute: "/signIn",
                      ),
                    );
                  },
                ),
                SizedBox(
                    width: 10
                ),
                FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
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
