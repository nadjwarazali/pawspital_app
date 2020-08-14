import 'package:flutter/material.dart';
import 'package:pawspitalapp/services/provider_widget.dart';
import 'package:pawspitalapp/models/user.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  User user = new User("");
  TextEditingController _userAddressController = TextEditingController();
//  TextEditingController _userPhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Color.fromRGBO(220, 190, 181, 1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
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
            "Name: ${authData.displayName ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              _userAddressController.text = user.address;
//              _userPhoneNumberController.text = user.phoneNumber;
            }
            return  Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Address: ${_userAddressController.text}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
////                    "Phone Number: ${_userPhoneNumberController.text}",
//                    style: TextStyle(fontSize: 20),
//                  ),
//                ),
              ],
            );
          }
        ),
        showSignOut(context, authData.isAnonymous),
        RaisedButton(
          child: Text("Edit User"),
          onPressed: () {
            _userEditBottomSheet(context);
          },
        )
      ],
    );
  }

  _getProfileData() async{

    final uid = await Provider.of(context).auth.getCurrentUID();
    await Provider.of(context).db.collection("userData").document(uid).get().then((result){
      user.address = result.data['address'];
//      user.phoneNumber = result.data['phoneNumber'];

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
        onPressed: () async {
          try {
            await Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }

  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Details ",
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
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
                          ),
                        ],
                      ),
//                      Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: Padding(
//                              padding: const EdgeInsets.only(right: 15.0),
//                              child: TextField(
//                                controller: _userPhoneNumberController,
//                                decoration: InputDecoration(
//                                  helperText: "Phone Number",
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Save"),
                            color: Colors.grey,
                            textColor: Colors.white,
                            onPressed: () async {
                              user.address = _userAddressController.text;
//                              user.phoneNumber =
//                                  _userPhoneNumberController.text;

                              setState(() {
                                _userAddressController.text = user.address;
//                                _userPhoneNumberController.text = user.phoneNumber;
                            });

                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              await Provider.of(context)
                                  .db
                                  .collection("userData")
                                  .document(uid)
                                  .setData(user.toJson());

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
