import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:aetram/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetPortfolioHoldingsUseCase {
  final PortfolioRepository _repository;

  GetPortfolioHoldingsUseCase(this._repository);

  Future<List<PortfolioHoldingEntity>> call() async {
    return await _repository.getHoldings();
  }
}
