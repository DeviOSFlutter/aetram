class CandleEntity {
  final int bucket;

  final double open;

  final double high;

  final double low;

  final double close;

  final DateTime? timestamp;

  const CandleEntity({
    required this.bucket,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.timestamp,
  });

  bool get isBullish => close >= open;

  CandleEntity copyWith({
    double? high,
    double? low,
    double? close,
    DateTime? timestamp,
  }) {
    return CandleEntity(
      bucket: bucket,
      open: open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
