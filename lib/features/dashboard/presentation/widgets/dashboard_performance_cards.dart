import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:aetram/features/portfolio/domain/entities/portfolio_holding_entity.dart';
import 'package:flutter/material.dart';

class DashboardPerformanceCards extends StatelessWidget {
  final DashboardController controller;

  const DashboardPerformanceCards({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
}
