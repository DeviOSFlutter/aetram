import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:aetram/features/symbol_search/domain/usecases/get_symbols_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymbolSearchController extends GetxController {
  final GetSymbolsUseCase _getSymbolsUseCase;

  SymbolSearchController(this._getSymbolsUseCase);

  final TextEditingController searchController = TextEditingController();

  final RxBool isLoading = false.obs;

  final RxList<SymbolEntity> symbols = <SymbolEntity>[].obs;

  final RxList<SymbolEntity> filteredSymbols = <SymbolEntity>[].obs;

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

      final result = await _getSymbolsUseCase();

      symbols.assignAll(result);

      filteredSymbols.assignAll(result);
    } catch (e) {
      errorMessage.value = AppStrings.somethingWentWrong;
    } finally {
      isLoading.value = false;
    }
  }

  void filterSymbols(String query) {
    if (query.trim().isEmpty) {
      filteredSymbols.assignAll(symbols);

      return;
    }

    final String lowerQuery = query.toLowerCase();

    final List<SymbolEntity> results = symbols.where((symbol) {
      return symbol.symbol.toLowerCase().contains(lowerQuery) ||
          symbol.name.toLowerCase().contains(lowerQuery);
    }).toList();

    filteredSymbols.assignAll(results);
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.dispose();

    super.onClose();
  }
}
