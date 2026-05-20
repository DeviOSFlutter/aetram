import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<ThemeController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appTitle,
        ),
        actions: [
          GetBuilder<ThemeController>(
            builder: (controller) {
              return IconButton(
                onPressed: controller.toggleTheme,
                icon: Icon(
                  controller.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          AppStrings.appTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}