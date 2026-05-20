import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:aetram/features/portfolio/domain/repositories/portfolio_repository.dart';

class SavePortfolioHoldingUseCase {
  final PortfolioRepository _repository;

  SavePortfolioHoldingUseCase(this._repository);

  Future<void> call(PortfolioHoldingEntity holding) async {
    await _repository.saveHolding(holding);
  }
}
