import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/di/initial_binding.dart';
import 'package:aetram/core/routes/app_pages.dart';
import 'package:aetram/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            viewInsets: EdgeInsets.only(
              left: mediaQueryData.viewInsets.left.clamp(0.0, double.infinity),
              top: mediaQueryData.viewInsets.top.clamp(0.0, double.infinity),
              right: mediaQueryData.viewInsets.right.clamp(0.0, double.infinity),
              bottom: mediaQueryData.viewInsets.bottom.clamp(0.0, double.infinity),
            ),
            viewPadding: EdgeInsets.only(
              left: mediaQueryData.viewPadding.left.clamp(0.0, double.infinity),
              top: mediaQueryData.viewPadding.top.clamp(0.0, double.infinity),
              right: mediaQueryData.viewPadding.right.clamp(0.0, double.infinity),
              bottom: mediaQueryData.viewPadding.bottom.clamp(0.0, double.infinity),
            ),
            padding: EdgeInsets.only(
              left: mediaQueryData.padding.left.clamp(0.0, double.infinity),
              top: mediaQueryData.padding.top.clamp(0.0, double.infinity),
              right: mediaQueryData.padding.right.clamp(0.0, double.infinity),
              bottom: mediaQueryData.padding.bottom.clamp(0.0, double.infinity),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}