import 'package:aetram/features/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'package:aetram/features/portfolio/data/models/portfolio_holding_model.dart';
import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:aetram/features/portfolio/domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource _localDataSource;

  PortfolioRepositoryImpl(this._localDataSource);

  @override
  Future<List<PortfolioHoldingEntity>> getHoldings() async {
    return await _localDataSource.getHoldings();
  }

  @override
  Future<void> saveHolding(PortfolioHoldingEntity holding) async {
    final List<PortfolioHoldingModel> holdings = await _localDataSource.getHoldings();
    
    final int existingIndex = holdings.indexWhere((h) => h.symbol == holding.symbol);
    
    if (existingIndex >= 0) {
      final PortfolioHoldingModel oldHolding = holdings[existingIndex];
      final double totalQuantity = oldHolding.quantity + holding.quantity;
      final double totalCost = (oldHolding.quantity * oldHolding.averageBuyPrice) + 
                               (holding.quantity * holding.averageBuyPrice);
      final double newAveragePrice = totalQuantity > 0 ? (totalCost / totalQuantity) : 0.0;
      
      holdings[existingIndex] = PortfolioHoldingModel(
        symbol: holding.symbol,
        quantity: totalQuantity,
        averageBuyPrice: newAveragePrice,
        createdAt: oldHolding.createdAt,
      );
    } else {
      holdings.add(PortfolioHoldingModel(
        symbol: holding.symbol,
        quantity: holding.quantity,
        averageBuyPrice: holding.averageBuyPrice,
        createdAt: holding.createdAt,
      ));
    }
    
    await _localDataSource.saveHoldings(holdings);
  }
}
