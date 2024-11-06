import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
  });

  const ProfileImage.appBar({
    Key? key,
    required String imageUrl,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 40,
        );

  const ProfileImage.content({
    Key? key,
    required String imageUrl,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 25,
        );

  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<AppbarProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusCircular,
      onTap: () {
        // TODO: burada kullanıcının kendi id si verilecek
        appbarProvider.profile("aq6tj5sxc");
      },
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
