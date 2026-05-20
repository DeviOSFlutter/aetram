import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/features/chart/presentation/widgets/candle_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

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
                  onPressed: () => Get.toNamed(AppRoutes.fullscreenChart),
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
