import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:blackbox_db/8_Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatefulWidget {
  const UserItem({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late final managerPanelProvider = context.read<ManagerPanelProvider>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfilePicture.manager(
            userId: widget.userModel.id,
            imageUrl: widget.userModel.picturePath,
          ),
          const SizedBox(width: 10),
          Text(
            widget.userModel.username,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              await managerPanelProvider.deleteUser(userId: widget.userModel.id);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
