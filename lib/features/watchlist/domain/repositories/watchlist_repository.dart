import '../entities/watchlist_item_entity.dart';

abstract class WatchlistRepository {
  Future<void> saveWatchlist(List<WatchlistItemEntity> symbols);

  List<WatchlistItemEntity> getWatchlist();
}
