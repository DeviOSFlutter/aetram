import 'package:aetram/core/storage/storage_keys.dart';
import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/features/watchlist/data/models/watchlist_item_model.dart';

class WatchlistLocalDataSource {
  final StorageService _storageService;

  WatchlistLocalDataSource(this._storageService);

  Future<void> saveWatchlist(List<WatchlistItemModel> symbols) async {
    final List<Map<String, dynamic>> data = symbols
        .map((e) => e.toJson())
        .toList();

    await _storageService.write(StorageKeys.watchlistSymbols, data);
  }

  List<WatchlistItemModel> getWatchlist() {
    final List<dynamic>? data = _storageService.read<List<dynamic>>(
      StorageKeys.watchlistSymbols,
    );

    if (data == null) {
      return [];
    }

    return data
        .map(
          (json) =>
              WatchlistItemModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }
}
