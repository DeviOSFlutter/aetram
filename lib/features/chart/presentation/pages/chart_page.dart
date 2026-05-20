import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/features/chart/presentation/widgets/chart_hero_section.dart';
import 'package:aetram/features/chart/presentation/widgets/chart_range_selector.dart';
import 'package:aetram/features/chart/presentation/widgets/chart_section.dart';
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

                return ChartHeroSection(
                  symbol: symbol,
                  ltp: ltp,
                  change: change,
                  changePercentage: changePercentage,
                  isPositive: isPositive,
                  controller: controller,
                );
              }),
              AppSizes.verticalSpaceLarge,
              ChartRangeSelector(controller: controller),
              AppSizes.verticalSpaceLarge,
              const ChartSection(),
            ],
          ),
        ),
      ),
    );
  }
}
