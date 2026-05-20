import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/domain/repositories/watchlist_repository.dart';

class SaveWatchlistUseCase {
  final WatchlistRepository _repository;

  SaveWatchlistUseCase(this._repository);

  Future<void> call(List<WatchlistItemEntity> symbols) {
    return _repository.saveWatchlist(symbols);
  }
}
