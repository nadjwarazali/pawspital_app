import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawspitalapp/models/user.dart';
import 'package:pawspitalapp/models/user_model.dart';
import 'package:pawspitalapp/screens/profile/avatar_big.dart';
import 'package:pawspitalapp/screens/profile/user_controller.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/shared/button.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';
import 'package:pawspitalapp/shared/locator.dart';
import 'package:pawspitalapp/shared/textField.dart';
import 'manage_profile_information_widget.dart';
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: _width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text("Edit Profile", style: TextStyle(color: Colors.black)),
              centerTitle: true,
            ),
            SizedBox(height: 20),
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
            ),
            Expanded(
              flex: 2,
              child: ManagePasswordWidget(
                currentUser: _currentUser,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
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
              return Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Address: ${user.address}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          _userEditBottomSheet(context);
                        },
                      ),
                    ],
                  ),

                ),
              );
            }
        ),
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

  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left:20, bottom: 20),
                  child: CustomTextField(
                    controller: _userAddressController,
                    decoration: locator
                        .get<InputTextDeco>()
                        .inputTextDeco("Address"),
                  ),
                ),
                CustomButton(
                  text: 'Save',
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
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          ],
        );
      },
    );
  }

}
