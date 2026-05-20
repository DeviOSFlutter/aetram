import '../../domain/entities/symbol_entity.dart';

class SymbolModel extends SymbolEntity {
  const SymbolModel({
    required super.symbol,
    required super.name,
    required super.exchange,
    required super.type,
    required super.isActive,
  });

  factory SymbolModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SymbolModel(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      exchange: json['exchange'] ?? '',
      type: json['type'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}