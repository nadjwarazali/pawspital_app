import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  //final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0),
            child: Text(
              "Maps",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
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
    );
  }
}
