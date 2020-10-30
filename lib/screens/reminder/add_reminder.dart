import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawspitalapp/models/reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/shared/textField.dart';
import '../../main.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _notesController = new TextEditingController();
  TextEditingController _petController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    _titleController.text = widget.reminder.reminderTitle;
    _locationController.text = widget.reminder.location;
    _notesController.text = widget.reminder.notes;
    _petController.text = widget.reminder.pet;

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              AppBar(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                elevation: 0,
                leading: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title:
                    Text("Add Reminder", style: TextStyle(color: Colors.black)),
                centerTitle: true,
              ),
              SizedBox(
                height: 170,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomButton(
                            text: 'Date Time',
                            onPressed: () async {
                              showDateTimeDialog(context,
                                  initialDate: selectedDate,
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
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(dateFormat.format(selectedDate)),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomTextField(
                            controller: _titleController,
                            decoration: locator
                                .get<InputTextDeco>()
                                .inputTextDeco("Reminder"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            controller: _locationController,
                            decoration: locator
                                .get<InputTextDeco>()
                                .inputTextDeco("Location"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            controller: _notesController,
                            decoration: locator
                                .get<InputTextDeco>()
                                .inputTextDeco("Notes"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            controller: _petController,
                            decoration: locator
                                .get<InputTextDeco>()
                                .inputTextDeco("Pet"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: CustomButton(
                              text: 'Save',
                              onPressed: () async {
                                widget.reminder.reminderTitle =
                                    _titleController.text;
                                widget.reminder.location =
                                    _locationController.text;
                                widget.reminder.notes = _notesController.text;
                                widget.reminder.pet = _petController.text;
                                widget.reminder.selectedDate = selectedDate;

                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                await db
                                    .collection("userData")
                                    .document(uid)
                                    .collection("reminders")
                                    .add(widget.reminder.toJson())
                                    .then((value) => _titleController.clear())
                                    .then(
                                        (value) => _locationController.clear())
                                    .then((value) => _notesController.clear())
                                    .then((value) => _petController.clear());
                                scheduleReminder(_titleController.text,
                                    _locationController.text, selectedDate);
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scheduleReminder(
      String title, String location, DateTime selectedDate) async {
    var scheduleNotificationDateTime = selectedDate;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly location',
      icon: 'app_icon',
      //sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      //sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, title, location,
        scheduleNotificationDateTime, platformChannelSpecifics);
  }
}
