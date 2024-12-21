import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blackbox_db/1%20Core/helper.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

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
  if (Platform.isWindows) {
    await WindowsSingleInstance.ensureSingleInstance(args, "multiple_timer", onSecondWindow: (args) {
      debugPrint(args.toString());
    });
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(1920 * 0.8, 1080 * 0.8),
      maximumSize: Size(9999, 9999),
      minimumSize: Size(1200, 800),
      // center: true,
      backgroundColor: Colors.transparent,
      // skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
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
