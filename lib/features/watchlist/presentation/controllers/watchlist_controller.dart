import 'dart:async';

import 'package:aetram/core/socket/socket_service.dart';
import 'package:aetram/core/socket/socket_status.dart';
import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/watchlist/data/models/tick_model.dart';
import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:aetram/features/watchlist/domain/usecases/save_watchlist_usecase.dart';
import 'package:get/get.dart';

class WatchlistController extends GetxController {
  final GetWatchlistUseCase _getWatchlistUseCase;

  final SaveWatchlistUseCase _saveWatchlistUseCase;

  final SocketService _socketService;

  WatchlistController(
    this._getWatchlistUseCase,
    this._saveWatchlistUseCase,
    this._socketService,
  );

  Rx<SocketStatus> get connectionStatus => _socketService.connectionStatus;

  final RxList<WatchlistItemEntity> watchlist = <WatchlistItemEntity>[].obs;

  final RxMap<String, TickEntity> liveTicks = <String, TickEntity>{}.obs;

  final RxString activeChartSymbol = ''.obs;

  final RxMap<String, List<CandleEntity>> symbolCandles =
      <String, List<CandleEntity>>{}.obs;

  static const int _bucketSize = 5;

  void setActiveChartSymbol(String symbol) {
    activeChartSymbol.value = symbol;
    _subscribeToWatchlist();
  }

  void clearActiveChartSymbol() {
    activeChartSymbol.value = '';
    _subscribeToWatchlist();
  }

  StreamSubscription? _tickerSubscription;

  @override
  void onInit() {
    super.onInit();

    loadWatchlist();

    _listenToTicks();
  }

  void loadWatchlist() {
    final result = _getWatchlistUseCase();

    watchlist.assignAll(result);

    _subscribeToWatchlist();
  }

  Future<void> addSymbol(String symbol) async {
    final bool alreadyExists = watchlist.any((item) => item.symbol == symbol);

    if (alreadyExists) {
      return;
    }

    watchlist.add(WatchlistItemEntity(symbol: symbol));

    await _persistWatchlist();

    _subscribeToWatchlist();
  }

  Future<void> removeSymbol(String symbol) async {
    watchlist.removeWhere((item) => item.symbol == symbol);

    liveTicks.remove(symbol);

    await _persistWatchlist();

    _socketService.unsubscribe([symbol]);
  }

  Future<void> _persistWatchlist() async {
    await _saveWatchlistUseCase(watchlist.toList());
  }

  void _subscribeToWatchlist() {
    final List<String> symbols = watchlist.map((e) => e.symbol).toList();
    if (activeChartSymbol.value.isNotEmpty &&
        !symbols.contains(activeChartSymbol.value)) {
      symbols.add(activeChartSymbol.value);
    }

    _socketService.subscribe(symbols);
  }

  void _listenToTicks() {
    _tickerSubscription = _socketService.tickerStream.listen((event) {
      final TickModel tick = TickModel.fromJson(event);

      liveTicks[tick.symbol] = tick;

      _processCandleTick(tick);
    });
  }

  void _processCandleTick(TickEntity tick) {
    final int bucket =
        (tick.timestamp ?? DateTime.now()).millisecondsSinceEpoch ~/
            (_bucketSize * 1000);

    final List<CandleEntity> existingCandles = List<CandleEntity>.from(
      symbolCandles[tick.symbol] ?? [],
    );

    if (existingCandles.isEmpty) {
      existingCandles.add(
        CandleEntity(
          bucket: bucket,
          open: tick.ltp,
          high: tick.ltp,
          low: tick.ltp,
          close: tick.ltp,
        ),
      );

      symbolCandles[tick.symbol] = existingCandles;

      symbolCandles.refresh();

      return;
    }

    final CandleEntity latest = existingCandles.last;

    if (latest.bucket == bucket) {
      existingCandles[existingCandles.length - 1] = latest.copyWith(
        high: tick.ltp > latest.high ? tick.ltp : latest.high,
        low: tick.ltp < latest.low ? tick.ltp : latest.low,
        close: tick.ltp,
      );
    } else {
      existingCandles.add(
        CandleEntity(
          bucket: bucket,
          open: latest.close,
          high: tick.ltp,
          low: tick.ltp,
          close: tick.ltp,
        ),
      );
    }

    if (existingCandles.length > 80) {
      existingCandles.removeAt(0);
    }

    symbolCandles[tick.symbol] = existingCandles;

    symbolCandles.refresh();
  }

  TickEntity? getTick(String symbol) {
    return liveTicks[symbol];
  }

  @override
  void onClose() {
    _tickerSubscription?.cancel();

    super.onClose();
  }
}
