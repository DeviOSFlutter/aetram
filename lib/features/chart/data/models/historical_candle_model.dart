import 'package:aetram/features/chart/domain/entities/candle_entity.dart';

class HistoricalCandleModel {
  static CandleEntity fromJson(Map<String, dynamic> json, int index) {
    final double ltp =
        (json['LTP'] ??
                json['ltp'] ??
                json['close'] ??
                json['CLOSE'] ??
                0.0 as num)
            .toDouble();
    final DateTime? timestamp = json['TS'] != null
        ? DateTime.tryParse(json['TS'].toString())
        : (json['ts'] != null
              ? DateTime.tryParse(json['ts'].toString())
              : (json['timestamp'] != null
                    ? DateTime.tryParse(json['timestamp'].toString())
                    : null));
    return CandleEntity(
      bucket: index,
      open: (json['OPEN'] ?? json['open'] ?? ltp as num).toDouble(),
      high: (json['HIGH'] ?? json['high'] ?? ltp as num).toDouble(),
      low: (json['LOW'] ?? json['low'] ?? ltp as num).toDouble(),
      close: ltp,
      timestamp: timestamp,
    );
  }
}
