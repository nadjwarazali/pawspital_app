import 'package:flutter/material.dart';

class AvatarBig extends StatelessWidget {
  final String avatarUrl;
  final Function onTap;

  const AvatarBig({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: avatarUrl == null
          ? Icon(
              Icons.account_circle,
              size: 100.0,
            )
          : CircleAvatar(
              radius: 100.0,
              backgroundImage: NetworkImage(avatarUrl),
            ),
    );
  }
}
