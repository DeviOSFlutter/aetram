import 'package:aetram/features/watchlist/data/datasources/watchlist_local_datasource.dart';
import 'package:aetram/features/watchlist/data/models/watchlist_item_model.dart';
import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource _localDataSource;

  WatchlistRepositoryImpl(this._localDataSource);

  @override
  List<WatchlistItemEntity> getWatchlist() {
    return _localDataSource.getWatchlist();
  }

  @override
  Future<void> saveWatchlist(List<WatchlistItemEntity> symbols) async {
    final List<WatchlistItemModel> models = symbols
        .map((e) => WatchlistItemModel(symbol: e.symbol))
        .toList();

    await _localDataSource.saveWatchlist(models);
  }
}
