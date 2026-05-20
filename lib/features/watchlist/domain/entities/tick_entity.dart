class TickEntity {
  final String symbol;

  final double ltp;

  final double prevClose;

  final int sequenceNo;

  const TickEntity({
    required this.symbol,
    required this.ltp,
    required this.prevClose,
    required this.sequenceNo,
  });

  double get change => ltp - prevClose;

  double get changePercentage {
    if (prevClose == 0) {
      return 0;
    }

    return (change / prevClose) * 100;
  }
}
