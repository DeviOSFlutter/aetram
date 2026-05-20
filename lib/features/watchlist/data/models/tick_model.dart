import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';

class TickModel extends TickEntity {
  const TickModel({
    required super.symbol,
    required super.ltp,
    required super.prevClose,
    required super.sequenceNo,
    super.timestamp,
  });

  factory TickModel.fromJson(Map<String, dynamic> json) {
    return TickModel(
      symbol: json['symbol'] ?? json['SYMBOL'] ?? '',
      ltp: (json['ltp'] ?? json['LTP'] ?? 0 as num).toDouble(),
      prevClose: (json['prevClose'] ?? json['PREV_CLOSE'] ?? 0 as num)
          .toDouble(),
      sequenceNo: json['sequenceNo'] ?? json['SEQUENCE_NO'] ?? 0,
      timestamp: json['TS'] != null
          ? DateTime.tryParse(json['TS'].toString())
          : (json['ts'] != null
              ? DateTime.tryParse(json['ts'].toString())
              : (json['timestamp'] != null
                  ? DateTime.tryParse(json['timestamp'].toString())
                  : null)),
    );
  }
}
