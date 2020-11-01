import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawspitalapp/models/user.dart';
import 'package:pawspitalapp/models/user_model.dart';
import 'package:pawspitalapp/screens/profile/avatar_big.dart';
import 'package:pawspitalapp/screens/profile/user_controller.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'avatar.dart';

class ProfileView extends StatefulWidget {
  static String route = "profile-view";


  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user = new User("");
  TextEditingController _userAddressController = TextEditingController();

  UserModel _currentUser = locator.get<UserController>().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //  "EditProfile",
        // ),
        backgroundColor: Colors.white38,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width*0.4,
            width:  MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    child: AvatarBig(
                      avatarUrl: _currentUser?.avatarUrl,
                      onTap: () async {
                        File image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        await locator
                            .get<UserController>()
                            .uploadProfilePicture(image);
                        print("Profile Picture uploaded");

                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 17.0, left:10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hey',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                            "${_currentUser?.displayName ?? 'Pals'}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: Provider.of(context).auth.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return displayUserInformation(context, snapshot);
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        FutureBuilder(
            future: _getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user.address = _userAddressController.text;
              }
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Address: ${user.address}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),

                  ],
                ),
              );
            }
        ),
        RaisedButton(
          child: Text("Edit User"),
          onPressed: () {
            _userEditBottomSheet(context);
          },
        )
      ],
    );
  }

  _getProfileData() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get().then((result) {
      user.address = result.data['address'];
    });
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () {
          try {
            Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }


  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userAddressController,
                          decoration: InputDecoration(
                            helperText: "Address",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.address = _userAddressController.text;
                        setState(() {
                          _userAddressController.text = user.address;
                        });
                        final uid =
                        await Provider.of(context).auth.getCurrentUID();
                        await Provider.of(context)
                            .db
                            .collection('userData')
                            .document(uid)
                            .setData(user.toJson());
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
