import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:aetram/features/watchlist/domain/usecases/save_watchlist_usecase.dart';
import 'package:get/get.dart';

class WatchlistController extends GetxController {
  final GetWatchlistUseCase _getWatchlistUseCase;

  final SaveWatchlistUseCase _saveWatchlistUseCase;

  WatchlistController(this._getWatchlistUseCase, this._saveWatchlistUseCase);

  final RxList<WatchlistItemEntity> watchlist = <WatchlistItemEntity>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadWatchlist();
  }

  void loadWatchlist() {
    final result = _getWatchlistUseCase();

    watchlist.assignAll(result);
  }

  Future<void> addSymbol(String symbol) async {
    final bool alreadyExists = watchlist.any((item) => item.symbol == symbol);

    if (alreadyExists) {
      return;
    }

    watchlist.add(WatchlistItemEntity(symbol: symbol));

    await _persistWatchlist();
  }

  Future<void> removeSymbol(String symbol) async {
    watchlist.removeWhere((item) => item.symbol == symbol);

    await _persistWatchlist();
  }

  Future<void> _persistWatchlist() async {
    await _saveWatchlistUseCase(watchlist.toList());
  }
}
