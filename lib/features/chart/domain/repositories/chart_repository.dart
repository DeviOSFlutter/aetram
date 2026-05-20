import 'package:aetram/features/chart/domain/entities/candle_entity.dart';

abstract class ChartRepository {
  Future<List<CandleEntity>> getHistoricalCandles({
    required String symbol,
    required String interval,
  });

  Future<List<CandleEntity>> getRealtimeCurrentCandles({
    required String symbol,
  });
}
