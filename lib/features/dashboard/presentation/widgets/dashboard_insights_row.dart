import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/utils/format_utils.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

class DashboardInsightsRow extends StatelessWidget {
  final DashboardController controller;

  const DashboardInsightsRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildInsightCard(
            isDark: isDark,
            title: 'TOP GAINER',
            icon: Icons.rocket_launch_rounded,
            accent: FormatUtils.positiveColor,
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
            accent: FormatUtils.negativeColor,
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
                      FormatUtils.formatCurrency(data['ltp'] as double),
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
                      FormatUtils.formatPercentage(
                          data['changePercentage'] as double,
                          includeSign: isGainer),
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
}
