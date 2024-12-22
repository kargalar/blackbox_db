import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;
  final int userID;

  const ProfilePicture({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    required this.userID,
  });

  const ProfilePicture.appBar({
    Key? key,
    required String imageUrl,
    required int userID,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 40,
          userID: userID,
        );

  const ProfilePicture.content({
    Key? key,
    required String imageUrl,
    required int userID,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 30,
          userID: userID,
        );
  const ProfilePicture.profile({
    Key? key,
    required String imageUrl,
    required int userID,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 80,
          userID: userID,
        );
  const ProfilePicture.review({
    Key? key,
    required String imageUrl,
    required int userID,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 60,
          userID: userID,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppColors.borderRadiusCircular,
      onTap: () {
        context.read<GeneralProvider>().profile(userID);
      },
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.all(2),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
