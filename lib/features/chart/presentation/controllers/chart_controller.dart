import 'package:aetram/features/chart/domain/entities/chart_point_entity.dart';
import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final WatchlistController _watchlistController;

  ChartController(this._watchlistController);

  final RxString selectedSymbol = ''.obs;

  final RxList<ChartPointEntity> chartPoints = <ChartPointEntity>[].obs;

  Worker? _chartWorker;

  int _xCounter = 0;

  @override
  void onInit() {
    super.onInit();

    selectedSymbol.value = Get.arguments ?? '';

    _loadInitialPoint();

    _listenToRealtimeTicks();
  }

  void _loadInitialPoint() {
    final TickEntity? tick = _watchlistController.getTick(selectedSymbol.value);

    if (tick == null) {
      return;
    }

    chartPoints.add(ChartPointEntity(x: _xCounter.toDouble(), y: tick.ltp));

    _xCounter++;
  }

  void _listenToRealtimeTicks() {
    _chartWorker = ever<Map<String, TickEntity>>(
      _watchlistController.liveTicks,
      (_) {
        final TickEntity? tick = _watchlistController.getTick(
          selectedSymbol.value,
        );

        if (tick == null) {
          return;
        }

        if (chartPoints.isNotEmpty) {
          final lastPoint = chartPoints.last;

          if (lastPoint.y == tick.ltp) {
            return;
          }
        }

        chartPoints.add(ChartPointEntity(x: _xCounter.toDouble(), y: tick.ltp));

        _xCounter++;

        if (chartPoints.length > 120) {
          chartPoints.removeAt(0);
        }
      },
    );
  }

  TickEntity? get currentTick {
    return _watchlistController.getTick(selectedSymbol.value);
  }

  @override
  void onClose() {
    _chartWorker?.dispose();

    super.onClose();
  }
}
