import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final WatchlistController _watchlistController;

  ChartController(this._watchlistController);

  final RxString selectedSymbol = ''.obs;

  final RxList<CandleEntity> candles = <CandleEntity>[].obs;

  Worker? _tickWorker;

  static const int _bucketSize = 5;

  @override
  void onInit() {
    super.onInit();

    selectedSymbol.value = Get.arguments ?? '';

    _listenToTicks();
  }

  void _listenToTicks() {
    _tickWorker = ever<Map<String, TickEntity>>(
      _watchlistController.liveTicks,
      (_) {
        final TickEntity? tick = _watchlistController.getTick(
          selectedSymbol.value,
        );

        if (tick == null) {
          return;
        }

        _processTick(tick);
      },
    );
  }

  void _processTick(TickEntity tick) {
    final int currentBucket =
        DateTime.now().millisecondsSinceEpoch ~/ (_bucketSize * 1000);

    if (candles.isEmpty) {
      candles.add(
        CandleEntity(
          bucket: currentBucket,
          open: tick.ltp,
          high: tick.ltp,
          low: tick.ltp,
          close: tick.ltp,
        ),
      );

      return;
    }

    final CandleEntity latest = candles.last;

    if (latest.bucket == currentBucket) {
      final CandleEntity updated = latest.copyWith(
        high: tick.ltp > latest.high ? tick.ltp : latest.high,
        low: tick.ltp < latest.low ? tick.ltp : latest.low,
        close: tick.ltp,
      );

      candles[candles.length - 1] = updated;

      candles.refresh();

      return;
    }

    candles.add(
      CandleEntity(
        bucket: currentBucket,
        open: latest.close,
        high: tick.ltp,
        low: tick.ltp,
        close: tick.ltp,
      ),
    );

    if (candles.length > 50) {
      candles.removeAt(0);
    }
  }

  TickEntity? get currentTick {
    return _watchlistController.getTick(selectedSymbol.value);
  }

  @override
  void onClose() {
    _tickWorker?.dispose();

    super.onClose();
  }
}
