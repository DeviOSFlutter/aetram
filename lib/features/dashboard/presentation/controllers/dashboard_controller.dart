import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:aetram/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PortfolioController _portfolioController;
  final WatchlistController _watchlistController;

  DashboardController(this._portfolioController, this._watchlistController);

  PortfolioController get portfolioController => _portfolioController;

  RxList<PortfolioHoldingEntity> get holdings => _portfolioController.holdings;
  bool get hasHoldings => holdings.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    ever(_portfolioController.holdings, (_) => update());
    ever(_watchlistController.liveTicks, (_) => update());
  }

  double get totalInvested => _portfolioController.totalInvestedValue;
  double get totalCurrent => _portfolioController.totalCurrentValue;
  double get totalPnL => _portfolioController.totalPnL;
  double get totalPnLPercentage => _portfolioController.totalPnLPercentage;

  int get holdingsCount => holdings.length;

  PortfolioHoldingEntity? get bestPerformingHolding {
    if (holdings.isEmpty) return null;
    PortfolioHoldingEntity? best;
    double maxPct = -double.infinity;
    for (final h in holdings) {
      final pct = _portfolioController.getHoldingPnLPercentage(h);
      if (pct > maxPct) {
        maxPct = pct;
        best = h;
      }
    }
    return best;
  }

  PortfolioHoldingEntity? get worstPerformingHolding {
    if (holdings.isEmpty) return null;
    PortfolioHoldingEntity? worst;
    double minPct = double.infinity;
    for (final h in holdings) {
      final pct = _portfolioController.getHoldingPnLPercentage(h);
      if (pct < minPct) {
        minPct = pct;
        worst = h;
      }
    }
    return worst;
  }

  Map<String, dynamic>? get topGainer {
    final list = holdings.isNotEmpty
        ? holdings.map((h) => h.symbol).toList()
        : _watchlistController.watchlist.map((w) => w.symbol).toList();

    if (list.isEmpty) return null;

    String? bestSym;
    double maxChg = -double.infinity;
    for (final sym in list) {
      final tick = _watchlistController.getTick(sym);
      if (tick != null) {
        if (tick.changePercentage > maxChg) {
          maxChg = tick.changePercentage;
          bestSym = sym;
        }
      }
    }
    if (bestSym == null) return null;
    return {
      'symbol': bestSym,
      'changePercentage': maxChg,
      'ltp': _portfolioController.getLtp(bestSym),
    };
  }

  Map<String, dynamic>? get topLoser {
    final list = holdings.isNotEmpty
        ? holdings.map((h) => h.symbol).toList()
        : _watchlistController.watchlist.map((w) => w.symbol).toList();

    if (list.isEmpty) return null;

    String? worstSym;
    double minChg = double.infinity;
    for (final sym in list) {
      final tick = _watchlistController.getTick(sym);
      if (tick != null) {
        if (tick.changePercentage < minChg) {
          minChg = tick.changePercentage;
          worstSym = sym;
        }
      }
    }
    if (worstSym == null) return null;
    return {
      'symbol': worstSym,
      'changePercentage': minChg,
      'ltp': _portfolioController.getLtp(worstSym),
    };
  }
}
