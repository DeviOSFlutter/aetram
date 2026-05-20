import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_empty_state.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_holdings_list.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_insights_row.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_performance_cards.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_stats_grid.dart';
import 'package:aetram/features/dashboard/presentation/widgets/dashboard_summary_card.dart';
import 'package:aetram/features/dashboard/presentation/widgets/section_label.dart';
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
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          if (!controller.hasHoldings) {
            return const DashboardEmptyState();
          }
          return _buildDashboardContent(context, isDark);
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, bool isDark) {
    final bool multipleHoldings = controller.holdings.length > 1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardSummaryCard(controller: controller),
              AppSizes.verticalSpaceLarge,
              DashboardStatsGrid(controller: controller),
              if (multipleHoldings) ...[
                AppSizes.verticalSpaceMedium,
                const SectionLabel('MARKET INSIGHTS'),
                AppSizes.verticalSpaceSmall,
                DashboardInsightsRow(controller: controller),
                AppSizes.verticalSpaceMedium,
                const SectionLabel('HOLDINGS PERFORMANCE'),
                AppSizes.verticalSpaceSmall,
                DashboardPerformanceCards(controller: controller),
              ],
              AppSizes.verticalSpaceMedium,
              const SectionLabel('ALL HOLDINGS'),
              AppSizes.verticalSpaceSmall,
              DashboardHoldingsList(controller: controller),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
