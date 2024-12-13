import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/page_provider.dart';
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
          size: 30,
        );
  const ProfileImage.profile({
    Key? key,
    required String imageUrl,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 80,
        );
  const ProfileImage.review({
    Key? key,
    required String imageUrl,
  }) : this(
          key: key,
          imageUrl: imageUrl,
          size: 60,
        );

  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<GeneralProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusCircular,
      onTap: () {
        // TODO: burada kullanıcının kendi id si verilecek
        appbarProvider.profile("aq6tj5sxc");
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
