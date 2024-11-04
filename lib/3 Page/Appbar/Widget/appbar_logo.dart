import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarLogo extends StatelessWidget {
  const AppbarLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<AppbarProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        appbarProvider.home();
      },
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            "BlackBox DB",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
