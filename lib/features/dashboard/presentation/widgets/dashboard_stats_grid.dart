import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/utils/format_utils.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardController controller;

  const DashboardStatsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double invested = controller.totalInvested;
    final double current = controller.totalCurrent;
    final double pnl = controller.totalPnL;
    final double pnlPct = controller.totalPnLPercentage;

    final stats = [
      {
        'label': AppStrings.invested,
        'value': FormatUtils.formatCurrency(invested),
        'color': Theme.of(context).primaryColor,
        'icon': Icons.savings_outlined,
      },
      {
        'label': AppStrings.currentVal,
        'value': FormatUtils.formatCurrency(current),
        'color': Theme.of(context).colorScheme.secondary,
        'icon': Icons.trending_up_rounded,
      },
      {
        'label': AppStrings.pnl,
        'value': FormatUtils.formatCurrency(pnl, includeSign: true),
        'color': FormatUtils.getPnLColor(pnl),
        'icon': pnl >= 0
            ? Icons.arrow_circle_up_outlined
            : Icons.arrow_circle_down_outlined,
      },
      {
        'label': AppStrings.pnlPercent,
        'value': FormatUtils.formatPercentage(pnlPct, includeSign: true),
        'color': FormatUtils.getPnLColor(pnl),
        'icon': Icons.percent_rounded,
      },
    ];

    final double width = MediaQuery.of(context).size.width;
    // On web/desktop/tablet (width > 600), show 4 items in a row. Otherwise show 2.
    final int crossAxisCount = width > 600 ? 4 : 2;
    // Adjust aspect ratio to keep cards looking perfectly sized.
    final double childAspectRatio = width > 900
        ? 2.3
        : (width > 600 ? 1.9 : 1.65);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: childAspectRatio,
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
                  child: Icon(stat['icon'] as IconData, size: 16, color: color),
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
}
