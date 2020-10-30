import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/screens/authenticate/first_view.dart';
import 'package:pawspitalapp/screens/authenticate/sign_up_view.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS =
  IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
    (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  onSelectNotification: (String payload)async {
    if (payload !=null){
      debugPrint('notification payload:' + payload);
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        auth: AuthService(),
        db: Firestore.instance,
        child: MaterialApp(
          title: "Pawspital",
          theme: ThemeData(
          // Define the default brightness and colors.
//          brightness: Brightness.dark,
          primaryColor: Color.fromRGBO(172, 119, 119, 1),
          accentColor: Color.fromRGBO(255, 205, 181, 1),

          // Define the default font family.
//          fontFamily: 'Roboto',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
//          textTheme: TextTheme(
//          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//          ),
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomeController(),
            '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
            '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous),
            '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert),
          },
        ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

