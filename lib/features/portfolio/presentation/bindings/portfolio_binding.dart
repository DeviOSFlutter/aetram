import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/features/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'package:aetram/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:aetram/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:aetram/features/portfolio/domain/usecases/get_portfolio_holdings_usecase.dart';
import 'package:aetram/features/portfolio/domain/usecases/save_portfolio_holding_usecase.dart';
import 'package:aetram/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class PortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortfolioLocalDataSource>(
      () => PortfolioLocalDataSource(Get.find<StorageService>()),
    );

    Get.lazyPut<PortfolioRepository>(
      () => PortfolioRepositoryImpl(Get.find<PortfolioLocalDataSource>()),
    );

    Get.lazyPut<GetPortfolioHoldingsUseCase>(
      () => GetPortfolioHoldingsUseCase(Get.find<PortfolioRepository>()),
    );

    Get.lazyPut<SavePortfolioHoldingUseCase>(
      () => SavePortfolioHoldingUseCase(Get.find<PortfolioRepository>()),
    );

    Get.put<PortfolioController>(
      PortfolioController(
        Get.find<GetPortfolioHoldingsUseCase>(),
        Get.find<SavePortfolioHoldingUseCase>(),
        Get.find<WatchlistController>(),
      ),
      permanent: true,
    );
  }
}
