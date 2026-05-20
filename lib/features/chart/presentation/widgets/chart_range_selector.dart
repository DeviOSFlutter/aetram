import 'package:aetram/features/chart/domain/enums/chart_range.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartRangeSelector extends StatelessWidget {
  final ChartController controller;

  const ChartRangeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _RangeButton(
            label: '1D',
            isSelected: controller.selectedRange.value == ChartRange.oneDay,
            onTap: () => controller.changeRange(ChartRange.oneDay),
          ),
          const SizedBox(width: 12),
          _RangeButton(
            label: '1W',
            isSelected: controller.selectedRange.value == ChartRange.oneWeek,
            onTap: () => controller.changeRange(ChartRange.oneWeek),
          ),
          const SizedBox(width: 12),
          _RangeButton(
            label: '1M',
            isSelected: controller.selectedRange.value == ChartRange.oneMonth,
            onTap: () => controller.changeRange(ChartRange.oneMonth),
          ),
        ],
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
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
