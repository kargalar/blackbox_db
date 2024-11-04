import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:blackbox_db/6%20Provider/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarProfile extends StatelessWidget {
  const AppbarProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final appbarProvider = context.read<AppbarProvider>();

    // !!!!! aşğaıya doğru menu açılsın

    return Center(
      child: InkWell(
        borderRadius: AppColors.borderRadiusCircular,
        onTap: () {
          appbarProvider.updatePage(5);
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: AppColors.borderRadiusCircular,
            child: SizedBox(
              width: 45,
              height: 45,
              child: Image.network(
                fit: BoxFit.cover,
                "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
