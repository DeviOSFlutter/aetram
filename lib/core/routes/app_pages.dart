import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/features/splash/presentation/pages/splash_page.dart';
import 'package:aetram/features/symbol_search/presentation/bindings/symbol_search_binding.dart';
import 'package:aetram/features/symbol_search/presentation/pages/symbol_search_page.dart';
import 'package:aetram/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(
      name: AppRoutes.symbolSearch,
      page: () => const SymbolSearchPage(),
      binding: SymbolSearchBinding(),
    ),
    GetPage(name: AppRoutes.watchlist, page: () => const WatchlistPage()),
  ];
}
