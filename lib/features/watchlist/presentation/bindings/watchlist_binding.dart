import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/features/watchlist/data/datasources/watchlist_local_datasource.dart';
import 'package:aetram/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:aetram/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:aetram/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:aetram/features/watchlist/domain/usecases/save_watchlist_usecase.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class WatchlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchlistLocalDataSource>(
      () => WatchlistLocalDataSource(Get.find<StorageService>()),
    );

    Get.lazyPut<WatchlistRepository>(
      () => WatchlistRepositoryImpl(Get.find<WatchlistLocalDataSource>()),
    );

    Get.lazyPut<GetWatchlistUseCase>(
      () => GetWatchlistUseCase(Get.find<WatchlistRepository>()),
    );

    Get.lazyPut<SaveWatchlistUseCase>(
      () => SaveWatchlistUseCase(Get.find<WatchlistRepository>()),
    );

    Get.put<WatchlistController>(
      WatchlistController(
        Get.find<GetWatchlistUseCase>(),
        Get.find<SaveWatchlistUseCase>(),
      ),
      permanent: true,
    );
  }
}
