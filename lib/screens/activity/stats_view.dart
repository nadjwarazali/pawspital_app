import 'package:flutter/material.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(240, 188, 26, 1),
        title: Text("Activity Statistic",
          style: TextStyle(
          color: Colors.black, fontSize: 17
          ),
      ),
        elevation: 0.0,

      ),
    );
  }
}
