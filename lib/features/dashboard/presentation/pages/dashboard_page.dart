import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:aetram/features/main/presentation/controllers/main_controller.dart';
import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingMedium),
            child: Icon(
              Icons.bar_chart_rounded,
              color: isDark ? Colors.tealAccent : Colors.teal,
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Reading controller.holdings inside Obx registers this widget as a listener
        // on the underlying RxList, so the UI rebuilds whenever holdings change.
        final hasHoldings = controller.holdings.isNotEmpty;
        if (!hasHoldings) {
          return _buildEmptyState(context, isDark);
        }
        return _buildDashboardContent(context, isDark);
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.teal.withValues(alpha: 0.18),
                    Colors.teal.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 72,
                color: Colors.teal.withValues(alpha: 0.8),
              ),
            ),
            AppSizes.verticalSpaceLarge,
            Text(
              'No Portfolio Data Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSizes.verticalSpaceSmall,
            Text(
              'Your dashboard analytics will appear here once you purchase holdings from the Watchlist.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSizes.verticalSpaceLarge,
            _buildPlaceholderCards(isDark),
            AppSizes.verticalSpaceLarge,
            SizedBox(
              width: 240,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Get.find<MainController>().changeTab(1),
                icon: const Icon(Icons.search_rounded),
                label: const Text('Explore Watchlist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCards(bool isDark) {
    final labels = ['Total Invested', 'Current Value', 'Total P&L', 'P&L %'];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: labels.map((label) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.04),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.black.withValues(alpha: 0.07),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDashboardContent(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(isDark),
          AppSizes.verticalSpaceMedium,
          _buildStatsGrid(isDark),
          AppSizes.verticalSpaceMedium,
          _sectionLabel('MARKET INSIGHTS', isDark),
          AppSizes.verticalSpaceSmall,
          _buildInsightsRow(isDark),
          AppSizes.verticalSpaceMedium,
          _sectionLabel('HOLDINGS PERFORMANCE', isDark),
          AppSizes.verticalSpaceSmall,
          _buildPerformanceCards(isDark),
          AppSizes.verticalSpaceMedium,
          _sectionLabel('ALL HOLDINGS', isDark),
          AppSizes.verticalSpaceSmall,
          _buildHoldingsList(isDark),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    final double invested = controller.totalInvested;
    final double current = controller.totalCurrent;
    final double pnl = controller.totalPnL;
    final double pnlPct = controller.totalPnLPercentage;
    final bool isPositive = pnl >= 0;
    final Color pnlColor =
        isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252);
    final String sign = isPositive ? '+' : '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
              : [const Color(0xFF00695C), const Color(0xFF004D40)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL PORTFOLIO VALUE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.holdingsCount} Holdings',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '₹${current.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summarySubCol('Invested', '₹${invested.toStringAsFixed(2)}'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Returns',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6))),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 16,
                          color: pnlColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$sign₹${pnl.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: pnlColor),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: pnlColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$sign${pnlPct.toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: pnlColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summarySubCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDark) {
    final double invested = controller.totalInvested;
    final double current = controller.totalCurrent;
    final double pnl = controller.totalPnL;
    final double pnlPct = controller.totalPnLPercentage;
    final bool isPositive = pnl >= 0;
    final Color pnlColor =
        isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252);
    final String sign = isPositive ? '+' : '';

    final stats = [
      {
        'label': 'Invested',
        'value': '₹${invested.toStringAsFixed(2)}',
        'color': Colors.blue,
        'icon': Icons.savings_outlined,
      },
      {
        'label': 'Current Value',
        'value': '₹${current.toStringAsFixed(2)}',
        'color': Colors.teal,
        'icon': Icons.trending_up_rounded,
      },
      {
        'label': 'P&L',
        'value': '$sign₹${pnl.toStringAsFixed(2)}',
        'color': pnlColor,
        'icon': isPositive
            ? Icons.arrow_circle_up_outlined
            : Icons.arrow_circle_down_outlined,
      },
      {
        'label': 'P&L %',
        'value': '$sign${pnlPct.toStringAsFixed(2)}%',
        'color': pnlColor,
        'icon': Icons.percent_rounded,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: stats.map((stat) {
        final Color color = stat['color'] as Color;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border.all(color: color.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(stat['icon'] as IconData,
                      size: 16, color: color),
                ),
                const Spacer(),
                Text(
                  stat['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInsightsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildInsightCard(
            isDark: isDark,
            title: 'TOP GAINER',
            icon: Icons.rocket_launch_rounded,
            accent: const Color(0xFF00E676),
            data: controller.topGainer,
            isGainer: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInsightCard(
            isDark: isDark,
            title: 'TOP LOSER',
            icon: Icons.trending_down_rounded,
            accent: const Color(0xFFFF5252),
            data: controller.topLoser,
            isGainer: false,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required Color accent,
    required Map<String, dynamic>? data,
    required bool isGainer,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: accent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (data == null)
              Text('N/A',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade400))
            else ...[
              Text(
                data['symbol'] as String,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '₹${(data['ltp'] as double).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${isGainer ? '+' : ''}${(data['changePercentage'] as double).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCards(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildPerformanceCard(
            isDark: isDark,
            label: 'BEST PERFORMER',
            holding: controller.bestPerformingHolding,
            accent: const Color(0xFF00E676),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPerformanceCard(
            isDark: isDark,
            label: 'WORST PERFORMER',
            holding: controller.worstPerformingHolding,
            accent: const Color(0xFFFF5252),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard({
    required bool isDark,
    required String label,
    required PortfolioHoldingEntity? holding,
    required Color accent,
  }) {
    double? pct;
    if (holding != null) {
      pct = controller.portfolioController
          .getHoldingPnLPercentage(holding);
    }
    final bool isPos = (pct ?? 0) >= 0;
    final String sign = isPos ? '+' : '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            if (holding == null)
              Text('N/A',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade400))
            else ...[
              Text(
                holding.symbol,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$sign${pct?.toStringAsFixed(2) ?? '0.00'}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingsList(bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.holdings.length,
      separatorBuilder: (context, index) => AppSizes.verticalSpaceSmall,
      itemBuilder: (context, index) {
        final holding = controller.holdings[index];
        final ltp =
            controller.portfolioController.getLtp(holding.symbol);
        final atp =
            controller.portfolioController.getAtp(holding.symbol);
        final double liveLtp =
            ltp > 0 ? ltp : holding.averageBuyPrice;
        final double holdingPnl =
            controller.portfolioController.getHoldingPnL(holding);
        final double holdingPnlPct =
            controller.portfolioController
                .getHoldingPnLPercentage(holding);
        final bool isPositive = holdingPnl >= 0;
        final Color pnlColor =
            isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252);
        final String sign = isPositive ? '+' : '';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Get.toNamed('/chart', arguments: holding.symbol),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holding.symbol,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${holding.quantity.toStringAsFixed(0)} qty  ·  avg ₹${holding.averageBuyPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${liveLtp.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ltp > 0 ? Colors.blue : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: pnlColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$sign${holdingPnlPct.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: pnlColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (atp > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LTP vs VWAP',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500),
                          ),
                          Row(
                            children: [
                              Text(
                                '₹${liveLtp.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                              Text('  vs  ',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500)),
                              Text(
                                '₹${atp.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: liveLtp >= atp
                                      ? const Color(0xFF00E676)
                                      : const Color(0xFFFF5252),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade500,
        letterSpacing: 1.0,
      ),
    );
  }
}
