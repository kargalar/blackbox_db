import 'package:blackbox_db/8%20Model/user_model.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.user,
  });

  final UserModel user;

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
        if (user.bio != null)
          Text(user.bio!,
              style: const TextStyle(
                fontSize: 15,
              )),
      ],
    );
  }
}
