import 'package:flutter/material.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:pawspitalapp/screens/profile/user_controller.dart';
import 'package:pawspitalapp/shared/button.dart';

// TODO move this to tone location
enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            await UserController().signInWithEmailAndPassword2(
                _email,
                _password,
            );
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(_email, _password, _name);
            Navigator.of(context).pushReplacementNamed('/onBoard');
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            setState(() {
              _warning = "A password reset link has been sent to $_email";
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.singInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            await auth.convertUserWithEmail(_email, _password, _name);
            Navigator.of(context).pop();
            break;
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
          backgroundColor: Color.fromRGBO(255, 246, 243, 0),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitDoubleBounce(
                color: Colors.black,
              ),
              AutoSizeText(
                "Loading",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ));
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: _height,
            width: _width,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  showAlert(),
                  SizedBox(height: _height * 0.10),
                  buildHeaderText(),
                  SizedBox(height: _height * 0.05),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.red,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Register";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.w700),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // if were in the sign up state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        Material(
          elevation: 3,
          borderRadius: BorderRadiusDirectional.circular(20),
          child: TextFormField(
            cursorColor: Color.fromRGBO(172, 119, 119, 1),
            validator: NameValidator.validate,
            style: TextStyle(fontSize: 16.0),
            decoration: buildSignUpInputDecoration("Name"),
            onSaved: (value) => _name = value,
          ),
        ),
      );
      textFields.add(SizedBox(height: 15));
    }

    // add email & password
    textFields.add(
      Material(
        borderRadius: BorderRadiusDirectional.circular(20),
        elevation: 3,
        child: TextFormField(
          cursorColor: Color.fromRGBO(172, 119, 119, 1),
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 16.0),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      ),
    );
    textFields.add(SizedBox(height: 15));
    textFields.add(
      Material(
        borderRadius: BorderRadiusDirectional.circular(20),
        elevation: 3,
        child: TextFormField(
          cursorColor: Color.fromRGBO(172, 119, 119, 1),
          validator: PasswordValidator.validate,
          style: TextStyle(fontSize: 16.0),
          decoration: buildSignUpInputDecoration("Password"),
          obscureText: true,
          onSaved: (value) => _password = value,
        ),
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButtonText = "Cancel";
      _newFormState = "home";
      _submitButtonText = "Sign Up";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Padding(
        padding: const EdgeInsets.only(left: 225),
        child: showForgotPassword(_showForgotPassword),
      ),
      SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: Color.fromRGBO(64, 51, 84, 1),
            textColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _submitButtonText,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
              ),
            ),
            onPressed: submit,
          ),
        ),
      ),
      FlatButton(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 5.0, bottom: 5.0, left: 30.0, right: 30.0),
          child: Text(
            _switchButtonText,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.black,
          ),
          SizedBox(height: 10),
          GoogleSignInButton(
            onPressed: () async {
              try {
                if (authFormType == AuthFormType.convert) {
                  await _auth.convertWithGoogle();
                  Navigator.of(context).pop();
                } else {
                  await _auth.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch (e) {
                setState(() {
                  print(e);
                  _warning = e.message;
                });
              }
            },
          )
        ],
      ),
      visible: visible,
    );
  }
}
