class CandleEntity {
  final int bucket;

  final double open;

  final double high;

  final double low;

  final double close;

  const CandleEntity({
    required this.bucket,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isBullish =>
      close >= open;

  CandleEntity copyWith({
    double? high,
    double? low,
    double? close,
  }) {
    return CandleEntity(
      bucket: bucket,
      open: open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
    );
  }
}