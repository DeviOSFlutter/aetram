import 'package:aetram/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'package:aetram/features/main/presentation/controllers/main_controller.dart';
import 'package:aetram/features/portfolio/presentation/bindings/portfolio_binding.dart';
import 'package:aetram/features/watchlist/presentation/bindings/watchlist_binding.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    WatchlistBinding().dependencies();
    PortfolioBinding().dependencies();
    DashboardBinding().dependencies();

    Get.put<MainController>(MainController(), permanent: true);
  }
}
