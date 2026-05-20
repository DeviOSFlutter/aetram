import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:aetram/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(
      DashboardController(
        Get.find<PortfolioController>(),
        Get.find<WatchlistController>(),
      ),
      permanent: true,
    );
  }
}
