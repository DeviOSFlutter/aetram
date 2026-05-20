import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends GetView<ChartController> {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.chart)),
      body: Obx(() {
        final tick = controller.currentTick;

        if (tick == null) {
          return const Center(child: Text(AppStrings.noRealtimeData));
        }

        final bool isPositive = tick.change >= 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tick.symbol,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              AppSizes.verticalSpaceMedium,
              Text(
                '₹${tick.ltp.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              AppSizes.verticalSpaceSmall,
              Text(
                '${tick.change.toStringAsFixed(2)} (${tick.changePercentage.toStringAsFixed(2)}%)',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              AppSizes.verticalSpaceLarge,
              Container(
                height: 320,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: const Text('Chart Coming Next Step'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
