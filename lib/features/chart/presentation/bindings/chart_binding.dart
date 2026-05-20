import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChartController>(
      () => ChartController(Get.find<WatchlistController>()),
    );
  }
}
