class PortfolioHoldingEntity {
  final String symbol;
  final double quantity;
  final double averageBuyPrice;
  final DateTime createdAt;

  const PortfolioHoldingEntity({
    required this.symbol,
    required this.quantity,
    required this.averageBuyPrice,
    required this.createdAt,
  });
}
