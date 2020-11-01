import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final Function onTap;

  const Avatar({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: avatarUrl == null
          ? Icon(
              Icons.account_circle,
              size: 60.0,
            )
          : CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(avatarUrl),
            ),
    );
  }
}
