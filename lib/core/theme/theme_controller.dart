import 'package:aetram/core/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final StorageService _storageService;

  ThemeController(this._storageService);

  bool get isDarkMode => Get.isDarkMode;

  @override
  void onInit() {
    super.onInit();

    loadTheme();
  }

  void toggleTheme() {
    final bool enableDarkMode = !Get.isDarkMode;

    final ThemeMode themeMode =
        enableDarkMode
            ? ThemeMode.dark
            : ThemeMode.light;

    Get.changeThemeMode(themeMode);

    _storageService.saveThemeMode(enableDarkMode);

    update();
  }

  void loadTheme() {
    final bool isDarkMode =
        _storageService.getThemeMode();

    Get.changeThemeMode(
      isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
    );

    update();
  }
}