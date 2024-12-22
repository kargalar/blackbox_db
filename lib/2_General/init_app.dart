import 'dart:async';
import 'dart:io';
import 'package:blackbox_db/2_General/accessible.dart';
import 'package:blackbox_db/5_Service/server_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blackbox_db/1_Core/helper.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

// args for singlw window instance
Future<void> initApp(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock Orientation to Portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Helper().registerAdapters();

  // SharedPreferences
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  // isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

  // block multiple instances app
  // is windows
  if (!kIsWeb && Platform.isWindows) {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      title: "BlackBox DB",
      size: Size(1920 * 0.8, 1080 * 0.8),
      maximumSize: Size(9999, 9999),
      minimumSize: Size(1200, 800),
      backgroundColor: Colors.transparent,
      // fullScreen: false,
      // skipTaskbar: false,
      // center: true,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // auto login
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('email');
  final String? password = prefs.getString('password');
  if (email != null && password != null) {
    loginUser = await ServerManager().login(
      email: email,
      password: password,
      isAutoLogin: true,
    );
  }

  // Custom Error
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.main,
              borderRadius: AppColors.borderRadiusAll,
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    const Text(
                      "Error",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      details.exception.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };
}
