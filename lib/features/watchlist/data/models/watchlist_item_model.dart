import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';

class WatchlistItemModel extends WatchlistItemEntity {
  const WatchlistItemModel({required super.symbol});

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    return WatchlistItemModel(symbol: json['symbol'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'symbol': symbol};
  }
}
