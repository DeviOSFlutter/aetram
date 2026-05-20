import 'package:aetram/core/network/dio_client.dart';
import 'package:aetram/features/chart/data/datasources/historical_remote_datasource.dart';
import 'package:aetram/features/chart/data/repositories/chart_repository_impl.dart';
import 'package:aetram/features/chart/domain/repositories/chart_repository.dart';
import 'package:aetram/features/chart/domain/usecases/get_historical_candles_usecase.dart';
import 'package:aetram/features/chart/domain/usecases/get_realtime_current_candles_usecase.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoricalRemoteDataSource>(
      () => HistoricalRemoteDataSource(Get.find<DioClient>()),
    );

    Get.lazyPut<ChartRepository>(
      () => ChartRepositoryImpl(Get.find<HistoricalRemoteDataSource>()),
    );

    Get.lazyPut<GetHistoricalCandlesUseCase>(
      () => GetHistoricalCandlesUseCase(Get.find<ChartRepository>()),
    );

    Get.lazyPut<GetRealtimeCurrentCandlesUseCase>(
      () => GetRealtimeCurrentCandlesUseCase(Get.find<ChartRepository>()),
    );

    Get.lazyPut<ChartController>(
      () => ChartController(
        Get.find<WatchlistController>(),
        Get.find<GetHistoricalCandlesUseCase>(),
        Get.find<GetRealtimeCurrentCandlesUseCase>(),
      ),
    );
  }
}
