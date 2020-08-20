import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:intl/intl.dart';
import 'package:pawspitalapp/services/provider_widget.dart';

import 'date_time_dialog.dart';

class NewReminder extends StatefulWidget {
  final Reminder reminder;
  NewReminder({Key key, @required this.reminder}) : super(key: key);

  @override
  _NewReminderState createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {
  final db = Firestore.instance;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');


//  DateTime _startDate = DateTime.now();
//  DateTime _endDate = DateTime.now().add(Duration(days: 7));
//  TimeOfDay _time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

//  Future displayDateRangePicker(BuildContext context) async {
//    final List<DateTime> picked = await DateRangePicker.showDatePicker(
//        context: context,
//        initialFirstDate: _startDate,
//        initialLastDate: _endDate,
//        firstDate: new DateTime(DateTime.now().year - 50),
//        lastDate: new DateTime(DateTime.now().year + 50));
//    if (picked != null && picked.length == 2) {
//      setState(() {
//        _startDate = picked[0];
//        _endDate = picked[1];
//      });
//    }
//  }


  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _locationController = new TextEditingController();
    TextEditingController _notesController = new TextEditingController();
    TextEditingController _petController = new TextEditingController();
    _titleController.text = widget.reminder.reminderTitle;
    _locationController.text = widget.reminder.location;
    _notesController.text = widget.reminder.notes;
    _petController.text = widget.reminder.pet;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder Details",
        style: TextStyle(
          color: Colors.black,
        ),
        ),
        backgroundColor: Color.fromRGBO(240, 188, 26, 1),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(dateFormat.format(selectedDate)),
              RaisedButton(
                child: Text('Choose new date time'),
                onPressed: () async {
                  showDateTimeDialog(context, initialDate: selectedDate,
                      onSelectedDate: (selectedDate) {
                        setState(() {
                          this.selectedDate = selectedDate;
                        });
                      });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _titleController,
                  decoration: inputTextDeco("Reminder"),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _locationController,
                  decoration: inputTextDeco("Location"),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Container(
                  child: TextField(
                    controller: _notesController,
                    decoration: inputTextDeco("Notes"),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _petController,
                  decoration: inputTextDeco("Pet Name"),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () async {

//                  widget.reminder.endDate = _endDate;
                  widget.reminder.reminderTitle = _titleController.text;
                  widget.reminder.location = _locationController.text;
                  widget.reminder.notes = _notesController.text;
//                  widget.reminder.startDate = _startDate;
                  widget.reminder.pet = _petController.text;
                  widget.reminder.selectedDate = selectedDate;

                  final uid = await Provider.of(context).auth.getCurrentUID();
                  await db
                      .collection("userData")
                      .document(uid)
                      .collection("reminders")
                      .add(widget.reminder.toJson());
                  //return to homepage
                  Navigator.of(context).pop();
//                  Navigator.of(context).pop();
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
