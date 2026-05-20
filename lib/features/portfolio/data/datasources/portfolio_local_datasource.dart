import 'dart:convert';
import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/features/portfolio/data/models/portfolio_holding_model.dart';

class PortfolioLocalDataSource {
  final StorageService _storageService;
  static const String _storageKey = 'portfolio_holdings';

  PortfolioLocalDataSource(this._storageService);

  Future<List<PortfolioHoldingModel>> getHoldings() async {
    final String? holdingsJson = _storageService.read<String>(_storageKey);
    if (holdingsJson == null || holdingsJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decodedList =
          jsonDecode(holdingsJson) as List<dynamic>;
      return decodedList
          .map(
            (item) =>
                PortfolioHoldingModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveHoldings(List<PortfolioHoldingModel> holdings) async {
    final String encoded = jsonEncode(holdings.map((h) => h.toJson()).toList());
    await _storageService.write(_storageKey, encoded);
  }
}
