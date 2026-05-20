import 'package:aetram/features/splash/presentation/pages/splash_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const String initial = '/';

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: initial,
      page: () => const SplashPage(),
    ),
  ];
}