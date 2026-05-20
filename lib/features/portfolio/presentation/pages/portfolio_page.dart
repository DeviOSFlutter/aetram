import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/utils/format_utils.dart';
import 'package:aetram/features/main/presentation/controllers/main_controller.dart';
import 'package:aetram/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:aetram/shared/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioPage extends GetView<PortfolioController> {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoader();
        }

        if (controller.holdings.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  AppSizes.verticalSpaceLarge,
                  Text(
                    AppStrings.emptyPortfolioPageTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.verticalSpaceSmall,
                  Text(
                    AppStrings.emptyPortfolioPageSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.verticalSpaceLarge,
                  SizedBox(
                    width: 220,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.find<MainController>().changeTab(1);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(AppStrings.goToWatchlist),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final double invested = controller.totalInvestedValue;
        final double current = controller.totalCurrentValue;
        final double pnl = controller.totalPnL;
        final double pnlPct = controller.totalPnLPercentage;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B),
                          const Color(0xFF0F172A),
                        ]
                      : [
                          const Color(0xFFF1F5F9),
                          const Color(0xFFE2E8F0),
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.portfolioValue,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    AppSizes.verticalSpaceSmall,
                    Text(
                      FormatUtils.formatCurrency(current),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    AppSizes.verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.investedValue,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              FormatUtils.formatCurrency(invested),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppStrings.totalReturns,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  pnl >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 14,
                                  color: FormatUtils.getPnLColor(pnl),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${FormatUtils.formatCurrency(pnl, includeSign: true)} (${FormatUtils.formatPercentage(pnlPct, includeSign: true)})',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: FormatUtils.getPnLColor(pnl),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.holdingsHeader} (${controller.holdings.length})',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                itemCount: controller.holdings.length,
                separatorBuilder: (context, index) => AppSizes.verticalSpaceSmall,
                itemBuilder: (context, index) {
                  final holding = controller.holdings[index];
                  final ltp = controller.getLtp(holding.symbol);
                  final double currentLtp = ltp > 0 ? ltp : holding.averageBuyPrice;
                  final double holdingInvested = controller.getHoldingInvestedValue(holding);
                  final double holdingPnl = controller.getHoldingPnL(holding);
                  final double holdingPnlPct = controller.getHoldingPnLPercentage(holding);

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Get.toNamed('/chart', arguments: holding.symbol);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  holding.symbol,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: FormatUtils.getPnLColor(holdingPnl).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    FormatUtils.formatPercentage(holdingPnlPct, includeSign: true),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: FormatUtils.getPnLColor(holdingPnl),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSizes.verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.quantity,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      holding.quantity.toStringAsFixed(0),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.avgPrice,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      FormatUtils.formatCurrency(holding.averageBuyPrice),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Live LTP',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      FormatUtils.formatCurrency(currentLtp),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ltp > 0 ? Theme.of(context).primaryColor : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 24, thickness: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.investedValue,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      FormatUtils.formatCurrency(holdingInvested),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${AppStrings.returns} (${AppStrings.pnl})',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      FormatUtils.formatCurrency(holdingPnl, includeSign: true),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: FormatUtils.getPnLColor(holdingPnl),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
