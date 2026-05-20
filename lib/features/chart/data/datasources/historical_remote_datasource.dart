import 'package:aetram/core/network/dio_client.dart';

class HistoricalRemoteDataSource {
  final DioClient _dioClient;

  HistoricalRemoteDataSource(this._dioClient);

  Future<List<dynamic>> getHistoricalData({
    required String symbol,
    required String startDate,
    required String endDate,
  }) async {
    final response = await _dioClient.post(
      '/historical',
      data: {
        'symbol': symbol,
        'start_date': startDate,
        'end_date': endDate,
        'limit': 1000,
      },
    );

    final rawData = response.data['data'];
    if (rawData is List) {
      return rawData;
    }
    return [];
  }

  Future<List<dynamic>> getRealtimeCurrentData({
    required String symbol,
    int limit = 1000,
  }) async {
    final response = await _dioClient.post(
      '/realtime-current',
      data: {
        'symbol': symbol,
        'limit': limit,
      },
    );

    final rawData = response.data['data'];
    if (rawData is List) {
      return rawData;
    }
    return [];
  }
}
