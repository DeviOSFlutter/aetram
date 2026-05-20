import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/core/theme/theme_controller.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<ThemeController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GetBuilder<ThemeController>(
                  builder: (controller) {
                    return TextButton.icon(
                      onPressed: controller.toggleTheme,
                      icon: Icon(
                        controller.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      label: Text(
                        controller.isDarkMode
                            ? AppStrings.lightMode
                            : AppStrings.darkMode,
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Text(
                AppStrings.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizes.verticalSpaceMedium,
              Text(
                AppStrings.splashDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offNamed(AppRoutes.symbolSearch);
                    },
                    child: const Text(AppStrings.getStarted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
