class TickEntity {
  final String symbol;

  final double ltp;

  final double prevClose;

  final int sequenceNo;

  final DateTime? timestamp;

  /// Average Traded Price (VWAP) — nullable, populated only when the server sends it.
  final double? atp;

  const TickEntity({
    required this.symbol,
    required this.ltp,
    required this.prevClose,
    required this.sequenceNo,
    this.timestamp,
    this.atp,
  });

  double get change => ltp - prevClose;

  double get changePercentage {
    if (prevClose == 0) {
      return 0;
    }

    return (change / prevClose) * 100;
  }
}
