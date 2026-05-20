import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:aetram/features/portfolio/domain/usecases/get_portfolio_holdings_usecase.dart';
import 'package:aetram/features/portfolio/domain/usecases/save_portfolio_holding_usecase.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  final GetPortfolioHoldingsUseCase _getPortfolioHoldingsUseCase;
  final SavePortfolioHoldingUseCase _savePortfolioHoldingUseCase;
  final WatchlistController _watchlistController;

  PortfolioController(
    this._getPortfolioHoldingsUseCase,
    this._savePortfolioHoldingUseCase,
    this._watchlistController,
  );

  final RxList<PortfolioHoldingEntity> holdings =
      <PortfolioHoldingEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();
  }

  Future<void> loadPortfolio() async {
    isLoading.value = true;
    try {
      final list = await _getPortfolioHoldingsUseCase();
      holdings.assignAll(list);

      final List<String> symbols = list.map((h) => h.symbol).toList();
      _watchlistController.setPortfolioSymbols(symbols);
    } catch (e) {
      holdings.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyHolding({
    required String symbol,
    required double quantity,
    required double averageBuyPrice,
  }) async {
    final holding = PortfolioHoldingEntity(
      symbol: symbol,
      quantity: quantity,
      averageBuyPrice: averageBuyPrice,
      createdAt: DateTime.now(),
    );
    await _savePortfolioHoldingUseCase(holding);
    await loadPortfolio();
  }

  double getLtp(String symbol) {
    final tick = _watchlistController.getTick(symbol);
    return tick?.ltp ?? 0.0;
  }

  double getAtp(String symbol) {
    final tick = _watchlistController.getTick(symbol);
    return tick?.atp ?? 0.0;
  }

  double getHoldingInvestedValue(PortfolioHoldingEntity holding) {
    return holding.quantity * holding.averageBuyPrice;
  }

  double getHoldingCurrentValue(PortfolioHoldingEntity holding) {
    final ltp = getLtp(holding.symbol);
    final currentPrice = ltp > 0 ? ltp : holding.averageBuyPrice;
    return holding.quantity * currentPrice;
  }

  double getHoldingPnL(PortfolioHoldingEntity holding) {
    return getHoldingCurrentValue(holding) - getHoldingInvestedValue(holding);
  }

  double getHoldingPnLPercentage(PortfolioHoldingEntity holding) {
    final invested = getHoldingInvestedValue(holding);
    if (invested == 0) return 0.0;
    return (getHoldingPnL(holding) / invested) * 100;
  }

  double get totalInvestedValue {
    double total = 0.0;
    for (final holding in holdings) {
      total += getHoldingInvestedValue(holding);
    }
    return total;
  }

  double get totalCurrentValue {
    double total = 0.0;
    for (final holding in holdings) {
      total += getHoldingCurrentValue(holding);
    }
    return total;
  }

  double get totalPnL {
    return totalCurrentValue - totalInvestedValue;
  }

  double get totalPnLPercentage {
    final invested = totalInvestedValue;
    if (invested == 0) return 0.0;
    return (totalPnL / invested) * 100;
  }
}
