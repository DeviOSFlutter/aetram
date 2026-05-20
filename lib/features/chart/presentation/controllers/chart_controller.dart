import 'dart:async';

import 'package:aetram/core/socket/socket_service.dart';
import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/domain/enums/chart_range.dart';
import 'package:aetram/features/chart/domain/usecases/get_historical_candles_usecase.dart';
import 'package:aetram/features/chart/domain/usecases/get_realtime_current_candles_usecase.dart';
import 'package:aetram/features/watchlist/data/models/tick_model.dart';
import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final WatchlistController _watchlistController;

  final GetHistoricalCandlesUseCase _getHistoricalCandlesUseCase;

  final GetRealtimeCurrentCandlesUseCase _getRealtimeCurrentCandlesUseCase;

  ChartController(
    this._watchlistController,
    this._getHistoricalCandlesUseCase,
    this._getRealtimeCurrentCandlesUseCase,
  );

  final RxString selectedSymbol = ''.obs;

  final Rx<ChartRange> selectedRange = ChartRange.oneDay.obs;

  final RxBool isLoading = false.obs;

  final RxList<CandleEntity> historicalCandles = <CandleEntity>[].obs;

  final RxList<CandleEntity> oneDayCandles = <CandleEntity>[].obs;

  DateTime? latestLoadedTimestamp;

  StreamSubscription? _tickSubscription;

  @override
  void onInit() {
    super.onInit();

    selectedSymbol.value = Get.arguments ?? '';
    
    _watchlistController.setActiveChartSymbol(selectedSymbol.value);

    _loadInitialOneDayData();
    _listenToLiveTicks();
  }

  TickEntity? get currentTick {
    return _watchlistController.getTick(selectedSymbol.value);
  }

  List<CandleEntity> get candles {
    if (selectedRange.value == ChartRange.oneDay) {
      return oneDayCandles;
    }

    return historicalCandles;
  }

  Future<void> _loadInitialOneDayData() async {
    isLoading.value = true;
    try {
      final result = await _getRealtimeCurrentCandlesUseCase(
        symbol: selectedSymbol.value,
      );
      oneDayCandles.assignAll(result);

      if (oneDayCandles.isNotEmpty) {
        DateTime? maxTime;
        for (var candle in oneDayCandles) {
          if (candle.timestamp != null) {
            if (maxTime == null || candle.timestamp!.isAfter(maxTime)) {
              maxTime = candle.timestamp;
            }
          }
        }
        latestLoadedTimestamp = maxTime;
      }
    } catch (e) {
      oneDayCandles.clear();
    } finally {
      if (selectedRange.value == ChartRange.oneDay) {
        isLoading.value = false;
      }
    }
  }

  void _listenToLiveTicks() {
    final SocketService socketService = Get.find<SocketService>();
    _tickSubscription = socketService.tickerStream.listen((event) {
      final tick = TickModel.fromJson(event);
      if (tick.symbol == selectedSymbol.value &&
          selectedRange.value == ChartRange.oneDay) {
        _appendLiveTick(tick);
      }
    });
  }

  void _appendLiveTick(TickEntity tick) {
    // Deduplication filter: ignore ticks that are already loaded in REST seed
    if (tick.timestamp != null && latestLoadedTimestamp != null) {
      if (!tick.timestamp!.isAfter(latestLoadedTimestamp!)) {
        return;
      }
    }

    if (oneDayCandles.isEmpty) {
      if (!isLoading.value) {
        oneDayCandles.add(
          CandleEntity(
            bucket: 0,
            open: tick.ltp,
            high: tick.ltp,
            low: tick.ltp,
            close: tick.ltp,
            timestamp: tick.timestamp,
          ),
        );
        if (tick.timestamp != null) {
          latestLoadedTimestamp = tick.timestamp;
        }
      }
      return;
    }

    final latest = oneDayCandles.last;
    if (latest.close == tick.ltp) {
      if (tick.timestamp != null &&
          (latestLoadedTimestamp == null ||
              tick.timestamp!.isAfter(latestLoadedTimestamp!))) {
        latestLoadedTimestamp = tick.timestamp;
      }
      return;
    }

    oneDayCandles.add(
      CandleEntity(
        bucket: oneDayCandles.length,
        open: latest.close,
        high: tick.ltp > latest.close ? tick.ltp : latest.close,
        low: tick.ltp < latest.close ? tick.ltp : latest.close,
        close: tick.ltp,
        timestamp: tick.timestamp,
      ),
    );

    if (tick.timestamp != null) {
      latestLoadedTimestamp = tick.timestamp;
    }

    if (oneDayCandles.length > 500) {
      oneDayCandles.removeAt(0);
    }
  }

  Future<void> changeRange(ChartRange range) async {
    selectedRange.value = range;

    if (range == ChartRange.oneDay) {
      if (oneDayCandles.isEmpty) {
        await _loadInitialOneDayData();
      }
      return;
    }

    isLoading.value = true;

    try {
      final String interval = range == ChartRange.oneWeek ? '1W' : '1M';

      final result = await _getHistoricalCandlesUseCase(
        symbol: selectedSymbol.value,
        interval: interval,
      );

      if (selectedRange.value == range) {
        historicalCandles.assignAll(result);
      }
    } catch (e) {
      if (selectedRange.value == range) {
        historicalCandles.clear();
      }
    } finally {
      if (selectedRange.value == range) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    _tickSubscription?.cancel();
    _watchlistController.clearActiveChartSymbol();
    super.onClose();
  }
}
