import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/screens/maps/maps.dart';
import 'package:pawspitalapp/screens/profile/profile.dart';
import 'package:pawspitalapp/screens/activity/activity.dart';
import 'package:pawspitalapp/screens/reminder/reminder_view.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  //create page
  final ReminderView _reminder = ReminderView();
  final Activity _activity = new Activity();
  final Maps _location = new Maps();
  final Profile _profile = new Profile();

  Widget _showPage = new ReminderView();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _reminder;
        break;
      case 1:
        return _activity;
        break;
      case 2:
        return _location;
        break;
      case 3:
        return _profile;
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text(
              'No page found by pagechooser',
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _showPage,
      ),
      bottomNavigationBar: CurvedNavigationBar(
          color: Color.fromRGBO(240, 188, 26, 1),
          backgroundColor: Colors.white,
          height: 50,
          items: <Widget>[
            Icon(Icons.list,size: 20, color: Colors.black),
            Icon(Icons.show_chart,size: 20, color: Colors.black),
            Icon(Icons.location_on,size: 20, color: Colors.black),
            Icon(Icons.settings,size: 20, color: Colors.black),
          ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        onTap: (int tappedIndex){
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
        },
      ),
    );
  }
}
