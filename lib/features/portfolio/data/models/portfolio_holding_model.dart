import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';

class PortfolioHoldingModel extends PortfolioHoldingEntity {
  const PortfolioHoldingModel({
    required super.symbol,
    required super.quantity,
    required super.averageBuyPrice,
    required super.createdAt,
  });

  factory PortfolioHoldingModel.fromJson(Map<String, dynamic> json) {
    return PortfolioHoldingModel(
      symbol: json['symbol'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      averageBuyPrice: (json['averageBuyPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'quantity': quantity,
      'averageBuyPrice': averageBuyPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
