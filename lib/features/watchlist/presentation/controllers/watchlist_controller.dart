import 'dart:async';

import 'package:aetram/core/socket/socket_service.dart';
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

  final RxList<WatchlistItemEntity> watchlist = <WatchlistItemEntity>[].obs;

  final RxMap<String, TickEntity> liveTicks = <String, TickEntity>{}.obs;

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

    _socketService.subscribe(symbols);
  }

  void _listenToTicks() {
    _tickerSubscription = _socketService.tickerStream.listen((event) {
      final TickModel tick = TickModel.fromJson(event);

      liveTicks[tick.symbol] = tick;
    });
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
