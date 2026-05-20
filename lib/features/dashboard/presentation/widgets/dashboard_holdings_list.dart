import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/utils/format_utils.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardHoldingsList extends StatelessWidget {
  final DashboardController controller;

  const DashboardHoldingsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.holdings.length,
      separatorBuilder: (context, index) => AppSizes.verticalSpaceSmall,
      itemBuilder: (context, index) {
        final holding = controller.holdings[index];
        final ltp = controller.portfolioController.getLtp(holding.symbol);
        final atp = controller.portfolioController.getAtp(holding.symbol);
        final double liveLtp = ltp > 0 ? ltp : holding.averageBuyPrice;
        final double holdingPnl =
            controller.portfolioController.getHoldingPnL(holding);
        final double holdingPnlPct =
            controller.portfolioController.getHoldingPnLPercentage(holding);

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
                            '${holding.quantity.toStringAsFixed(0)} qty  ·  avg ${FormatUtils.formatCurrency(holding.averageBuyPrice)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            FormatUtils.formatCurrency(liveLtp),
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
                              color: FormatUtils.getPnLColor(holdingPnl)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              FormatUtils.formatPercentage(holdingPnlPct,
                                  includeSign: true),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: FormatUtils.getPnLColor(holdingPnl),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'LTP vs VWAP',
                            style: TextStyle(
                                fontSize: 11, color: Colors.teal),
                          ),
                          Row(
                            children: [
                              Text(
                                FormatUtils.formatCurrency(liveLtp),
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
                                FormatUtils.formatCurrency(atp),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: FormatUtils.getPnLColor(liveLtp - atp),
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
}
