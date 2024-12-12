import 'package:blackbox_db/2%20General/accessible.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user.username,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        Text(user.bio,
            style: const TextStyle(
              fontSize: 15,
            )),
      ],
    );
  }
}
