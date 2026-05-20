import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';

abstract class PortfolioRepository {
  Future<List<PortfolioHoldingEntity>> getHoldings();
  Future<void> saveHolding(PortfolioHoldingEntity holding);
}
