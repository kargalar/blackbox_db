import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/3_Page/Login/login_page.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/6_Provider/explore_provider.dart';
import 'package:blackbox_db/6_Provider/general_provider.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:blackbox_db/6_Provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:blackbox_db/2_General/init_app.dart';
import 'package:blackbox_db/3_Page/appbar_manager.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await initApp(args);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GeneralProvider()),
        ChangeNotifierProvider(create: (context) => ExploreProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ContentPageProvider()),
        ChangeNotifierProvider(create: (context) => ManagerPanelProvider()),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
      screenWidth = MediaQuery.of(context).size.width;
    }

    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'BlackBox DB',
          theme: AppColors().appTheme,
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          home: loginUser != null ? const AppbarManager() : const LoginPage(),
        );
      },
    );
  }
}
