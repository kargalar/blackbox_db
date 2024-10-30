import 'package:blackbox_db/1%20Core/Enums/status_enum.dart';
import 'package:blackbox_db/1%20Core/Widgets/sure_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:blackbox_db/2%20General/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class Helper {
  Future<void> getDialog({
    String? title,
    required String message,
    bool withTimer = false,
    Function? onAccept,
    acceptButtonText,
  }) async {
    await Get.dialog(
      CustomDialogWidget(
        title: title,
        contentText: message,
        withTimer: withTimer,
        onAccept: onAccept,
        acceptButtonText: acceptButtonText,
      ),
    );
  }

  void getMessage({
    String? title,
    required String message,
    StatusEnum status = StatusEnum.SUCCESS,
    IconData? icon,
    Duration? duration,
    Function? onMainButtonPressed,
    String? mainButtonText,
  }) {
    Get.snackbar(
      title ??
          (status == StatusEnum.WARNING
              ? "Warning"
              : status == StatusEnum.INFO
                  ? "Info"
                  : "Succes"),
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: status == StatusEnum.WARNING ? AppColors.red.withOpacity(0.9) : AppColors.panelBackground.withOpacity(0.9),
      animationDuration: const Duration(milliseconds: 500),
      duration: duration ?? (status == StatusEnum.WARNING ? const Duration(seconds: 4) : const Duration(seconds: 2)),
      dismissDirection: DismissDirection.horizontal,
      icon: icon != null
          ? Icon(icon)
          : (status == StatusEnum.WARNING
              ? const Icon(Icons.warning)
              : status == StatusEnum.INFO
                  ? const Icon(Icons.info)
                  : const Icon(Icons.check)),
      mainButton: onMainButtonPressed != null
          ? TextButton(
              onPressed: () {
                onMainButtonPressed();
                Get.back();
              },
              child: Text(
                mainButtonText ?? "Okay",
                style: const TextStyle(color: AppColors.white),
              ),
            )
          : null,
    );
  }

  Future<bool> photosAccessRequest() async {
    // android sürüm 33 den büyük ise photos izni alınmalı yoksa storage izni yeterli
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt >= 33) {
      await Permission.photos.request();
      if (await Permission.photos.isGranted == false) {
        Helper().getMessage(
          message: "You must give permission to continue.",
          status: StatusEnum.WARNING,
        );
        return false;
      }

      if (await Permission.photos.isGranted == false) {
        if (await Permission.photos.isPermanentlyDenied) {
          Helper().getDialog(
            message: "You must grant access to the photos to continue.",
            onAccept: () async {
              await openAppSettings();
            },
          );
          return false;
        } else if (!await Permission.photos.isGranted) {
          Helper().getMessage(
            message: "You must grant access to the photos to continue.",
            status: StatusEnum.WARNING,
          );
          return false;
        }
      }
    } else {
      await Permission.storage.request();

      if (await Permission.storage.isGranted == false) {
        if (await Permission.storage.isPermanentlyDenied) {
          Helper().getDialog(
            message: "You must grant storage access to continue.",
            onAccept: () async {
              await openAppSettings();
            },
          );
          return false;
        } else if (!await Permission.storage.isGranted) {
          Helper().getMessage(
            message: "You must grant storage access to continue.",
            status: StatusEnum.WARNING,
          );
          return false;
        }
      }
    }

    return true;
  }

  Color getColorForPercentage(double percentage) {
    // Yüzdeye göre kırmızıdan yeşile renk gradyanı oluşturun
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.orange;

    return Colors.red;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  bool isBeforeDay(DateTime date1, DateTime date2) {
    return date1.year < date2.year || (date1.year == date2.year && date1.month < date2.month) || (date1.year == date2.year && date1.month == date2.month && date1.day < date2.day);
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void registerAdapters() {
    //  Hive.initFlutter();
    // Hive.registerAdapter(PhotoAdapter());
  }
}
