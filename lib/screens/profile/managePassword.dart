import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:flutter/material.dart';

class ManageProfileInformationWidget extends StatefulWidget {

  @override
  _ManageProfileInformationWidgetState createState() =>
      _ManageProfileInformationWidgetState();
}

class _ManageProfileInformationWidgetState
    extends State<ManageProfileInformationWidget> {
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool checkCurrentPasswordValid = true;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20.0),
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Manage Password",
                      style: Theme.of(context).textTheme.display1,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        errorText: checkCurrentPasswordValid
                            ? null
                            : "Please double check your current password",
                      ),
                      controller: _passwordController,
                    ),
                    TextFormField(
                      decoration:
                      InputDecoration(hintText: "New Password"),
                      controller: _newPasswordController,
                      obscureText: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Repeat Password",
                      ),
                      obscureText: true,
                      controller: _repeatPasswordController,
                      validator: (value) {
                        return _newPasswordController.text == value
                            ? null
                            : "Please validate your entered password";
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () async {
                checkCurrentPasswordValid =
                await Provider.of(context).auth.validateCurrentPassword(
                    _passwordController.text);

                setState(() {});

                if (_formKey.currentState.validate() &&
                    checkCurrentPasswordValid) {
                  Provider.of(context).auth.updateUserPassword(
                      _newPasswordController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Save Profile"),
            )
          ],
        ),
      ),
    );
  }
}