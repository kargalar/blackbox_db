import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarLogo extends StatelessWidget {
  const AppbarLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final generalProvider = context.read<GeneralProvider>();

    return InkWell(
      borderRadius: AppColors.borderRadiusAll,
      onTap: () {
        generalProvider.home();
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
