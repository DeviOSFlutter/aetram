import 'package:aetram/core/network/dio_client.dart';
import 'package:aetram/features/symbol_search/data/datasources/symbol_remote_datasource.dart';
import 'package:aetram/features/symbol_search/data/repositories/symbol_repository_impl.dart';
import 'package:aetram/features/symbol_search/domain/repositories/symbol_repository.dart';
import 'package:aetram/features/symbol_search/domain/usecases/get_symbols_usecase.dart';
import 'package:aetram/features/symbol_search/presentation/controllers/symbol_search_controller.dart';
import 'package:get/get.dart';

class SymbolSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymbolRemoteDataSource>(
      () => SymbolRemoteDataSource(Get.find<DioClient>()),
    );

    Get.lazyPut<SymbolRepository>(
      () => SymbolRepositoryImpl(Get.find<SymbolRemoteDataSource>()),
    );

    Get.lazyPut<GetSymbolsUseCase>(
      () => GetSymbolsUseCase(Get.find<SymbolRepository>()),
    );

    Get.lazyPut<SymbolSearchController>(
      () => SymbolSearchController(Get.find<GetSymbolsUseCase>()),
    );
  }
}
