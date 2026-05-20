import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchlistUseCase {
  final WatchlistRepository _repository;

  GetWatchlistUseCase(this._repository);

  List<WatchlistItemEntity> call() {
    return _repository.getWatchlist();
  }
}
