import 'package:aetram/features/chart/data/datasources/historical_remote_datasource.dart';
import 'package:aetram/features/chart/data/models/historical_candle_model.dart';
import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/domain/repositories/chart_repository.dart';

class ChartRepositoryImpl implements ChartRepository {
  final HistoricalRemoteDataSource _remoteDataSource;

  ChartRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CandleEntity>> getHistoricalCandles({
    required String symbol,
    required String interval,
  }) async {
    // Always start from 2026-05-04 (the absolute beginning of the mock database) to ensure we always get data
    // regardless of where the active simulation clock is positioned.
    final String startDate = '2026-05-04';
    final String endDate = '2026-05-18';

    final result = await _remoteDataSource.getHistoricalData(
      symbol: symbol,
      startDate: startDate,
      endDate: endDate,
    );

    // Downsample raw list to at most 150 points for optimal rendering speed
    final List<dynamic> downsampled = [];
    if (result.length <= 150) {
      downsampled.addAll(result);
    } else {
      final double step = result.length / 150;
      for (int i = 0; i < 150; i++) {
        final int index = (i * step).toInt();
        downsampled.add(result[index]);
      }
    }

    return List.generate(downsampled.length, (index) {
      return HistoricalCandleModel.fromJson(
        Map<String, dynamic>.from(downsampled[index]),
        index,
      );
    });
  }

  @override
  Future<List<CandleEntity>> getRealtimeCurrentCandles({
    required String symbol,
  }) async {
    final result = await _remoteDataSource.getRealtimeCurrentData(
      symbol: symbol,
      limit: 1000,
    );

    // Downsample raw list to at most 150 points for optimal rendering speed
    final List<dynamic> downsampled = [];
    if (result.length <= 150) {
      downsampled.addAll(result);
    } else {
      final double step = result.length / 150;
      for (int i = 0; i < 150; i++) {
        final int index = (i * step).toInt();
        downsampled.add(result[index]);
      }
    }

    return List.generate(downsampled.length, (index) {
      return HistoricalCandleModel.fromJson(
        Map<String, dynamic>.from(downsampled[index]),
        index,
      );
    });
  }
}
