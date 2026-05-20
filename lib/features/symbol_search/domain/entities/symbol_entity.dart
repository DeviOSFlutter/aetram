class SymbolEntity {
  final String symbol;

  final String name;

  final String exchange;

  final String type;

  final bool isActive;

  const SymbolEntity({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.type,
    required this.isActive,
  });
}
