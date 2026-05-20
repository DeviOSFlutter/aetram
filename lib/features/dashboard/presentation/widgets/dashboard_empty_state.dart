import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/main/presentation/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
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
                AppStrings.emptyPortfolioTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              AppSizes.verticalSpaceSmall,
              Text(
                AppStrings.emptyPortfolioSubtitle,
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
                  label: const Text(AppStrings.exploreWatchlist),
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
      ),
    );
  }

  Widget _buildPlaceholderCards(bool isDark) {
    final labels = [
      AppStrings.investedValue,
      AppStrings.currentVal,
      AppStrings.totalPnL,
      AppStrings.pnlPercent
    ];
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
}
