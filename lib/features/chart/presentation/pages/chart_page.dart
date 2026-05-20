import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/chart/domain/enums/chart_range.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/features/chart/presentation/widgets/candle_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends GetView<ChartController> {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(controller.selectedSymbol.value)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final tick = controller.currentTick;
                final symbol = controller.selectedSymbol.value;

                double? ltp = tick?.ltp;
                if (ltp == null && controller.candles.isNotEmpty) {
                  ltp = controller.candles.last.close;
                }

                final double? change = tick?.change;
                final double? changePercentage = tick?.changePercentage;
                final bool isPositive = (change ?? 0) >= 0;

                return _HeroSection(
                  symbol: symbol,
                  ltp: ltp,
                  change: change,
                  changePercentage: changePercentage,
                  isPositive: isPositive,
                  controller: controller,
                );
              }),
              AppSizes.verticalSpaceLarge,
              _RangeSection(controller: controller),
              AppSizes.verticalSpaceLarge,
              _ChartSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final String symbol;

  final double? ltp;

  final double? change;

  final double? changePercentage;

  final bool isPositive;

  final ChartController controller;

  const _HeroSection({
    required this.symbol,
    required this.ltp,
    required this.change,
    required this.changePercentage,
    required this.isPositive,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPositive
              ? [
                  Colors.green.withValues(alpha: 0.22),
                  Colors.green.withValues(alpha: 0.04),
                ]
              : [
                  Colors.red.withValues(alpha: 0.22),
                  Colors.red.withValues(alpha: 0.04),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSizes.verticalSpaceMedium,
          Text(
            ltp != null ? '₹${ltp!.toStringAsFixed(2)}' : '₹--',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSizes.verticalSpaceSmall,

          Obx(
            () => Text(
              controller.selectedRange.value == ChartRange.oneDay
                  ? 'Live Market Session'
                  : controller.selectedRange.value == ChartRange.oneWeek
                  ? '1 Week Historical'
                  : '1 Month Historical',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppSizes.verticalSpaceSmall,
          if (change != null && changePercentage != null)
            Text(
              '${change!.toStringAsFixed(2)} (${changePercentage!.toStringAsFixed(2)}%)',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          else
            Text(
              '-- (--%)',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeSection extends StatelessWidget {
  final ChartController controller;

  const _RangeSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _RangeButton(
            label: '1D',
            isSelected: controller.selectedRange.value == ChartRange.oneDay,
            onTap: () {
              controller.changeRange(ChartRange.oneDay);
            },
          ),
          const SizedBox(width: 12),
          _RangeButton(
            label: '1W',
            isSelected: controller.selectedRange.value == ChartRange.oneWeek,
            onTap: () {
              controller.changeRange(ChartRange.oneWeek);
            },
          ),
          const SizedBox(width: 12),
          _RangeButton(
            label: '1M',
            isSelected: controller.selectedRange.value == ChartRange.oneMonth,
            onTap: () {
              controller.changeRange(ChartRange.oneMonth);
            },
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Market Chart',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.fullscreenChart);
                  },
                  icon: const Icon(Icons.fullscreen),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 360, child: CandleChart()),
          ],
        ),
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  final String label;

  final bool isSelected;

  final VoidCallback onTap;

  const _RangeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
