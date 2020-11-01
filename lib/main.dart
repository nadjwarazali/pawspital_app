import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pawspitalapp/navigation.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/screens/authenticate/first_view.dart';
import 'package:pawspitalapp/screens/authenticate/sign_up_view.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/screens/onboarding/setweight.dart';

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
          primaryColor: Color.fromRGBO(64, 51, 84, 1),
          accentColor: Color.fromRGBO(64, 51, 84, 1),
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomeController(),
            '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
            '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous),
            '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert),
            '/onBoard' : (BuildContext context) => SetWeight(),
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


