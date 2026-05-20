import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:aetram/features/symbol_search/domain/usecases/get_symbols_usecase.dart';
import 'package:get/get.dart';

class SymbolSearchController
    extends GetxController {
  final GetSymbolsUseCase _getSymbolsUseCase;

  SymbolSearchController(
    this._getSymbolsUseCase,
  );

  final RxBool isLoading = false.obs;

  final RxList<SymbolEntity> symbols =
      <SymbolEntity>[].obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchSymbols();
  }

  Future<void> fetchSymbols() async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      final result =
          await _getSymbolsUseCase();

      symbols.assignAll(result);
    } catch (e) {
      errorMessage.value =
          AppStrings.somethingWentWrong;
    } finally {
      isLoading.value = false;
    }
  }
}