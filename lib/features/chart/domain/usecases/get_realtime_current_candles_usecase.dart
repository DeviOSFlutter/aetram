import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/domain/repositories/chart_repository.dart';

class GetRealtimeCurrentCandlesUseCase {
  final ChartRepository _repository;

  GetRealtimeCurrentCandlesUseCase(this._repository);

  Future<List<CandleEntity>> call({
    required String symbol,
  }) {
    return _repository.getRealtimeCurrentCandles(symbol: symbol);
  }
}
