import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final WatchlistController _watchlistController;

  ChartController(this._watchlistController);

  final RxString selectedSymbol = ''.obs;

  @override
  void onInit() {
    super.onInit();

    selectedSymbol.value = Get.arguments ?? '';
  }

  TickEntity? get currentTick {
    return _watchlistController.getTick(selectedSymbol.value);
  }
}
