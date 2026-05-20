import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/domain/repositories/chart_repository.dart';

class GetHistoricalCandlesUseCase {
  final ChartRepository _repository;

  GetHistoricalCandlesUseCase(this._repository);

  Future<List<CandleEntity>> call({
    required String symbol,
    required String interval,
  }) {
    return _repository.getHistoricalCandles(symbol: symbol, interval: interval);
  }
}
