import 'package:aetram/core/utils/app_sizes.dart';
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
}
