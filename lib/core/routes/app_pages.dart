import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/features/chart/presentation/bindings/chart_binding.dart';
import 'package:aetram/features/chart/presentation/pages/chart_page.dart';
import 'package:aetram/features/chart/presentation/pages/fullscreen_chart_page.dart';
import 'package:aetram/features/main/presentation/bindings/main_binding.dart';
import 'package:aetram/features/main/presentation/pages/main_page.dart';
import 'package:aetram/features/splash/presentation/pages/splash_page.dart';
import 'package:aetram/features/symbol_search/presentation/bindings/symbol_search_binding.dart';
import 'package:aetram/features/symbol_search/presentation/pages/symbol_search_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),

    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    GetPage(
      name: AppRoutes.symbolSearch,
      page: () => const SymbolSearchPage(),
      binding: SymbolSearchBinding(),
    ),

    GetPage(
      name: AppRoutes.chart,
      page: () => const ChartPage(),
      binding: ChartBinding(),
    ),
    GetPage(
      name: AppRoutes.fullscreenChart,
      page: () => const FullscreenChartPage(),
    ),
  ];
}
