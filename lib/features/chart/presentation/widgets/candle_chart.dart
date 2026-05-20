import 'dart:math';

import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CandleChart extends GetView<ChartController> {
  const CandleChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<CandleEntity> candles = controller.candles;

      if (candles.isEmpty) {
        return const Center(child: Text('Waiting for candle data...'));
      }

      final List<double> highs = candles.map((e) => e.high).toList();

      final List<double> lows = candles.map((e) => e.low).toList();

      final double maxY = highs.reduce(max);

      final double minY = lows.reduce(min);

      final CandleEntity latest = candles.last;

      final bool isBullish = latest.close > latest.open;

      final bool isNeutral = (latest.close - latest.open).abs() < 0.15;

      final Color chartColor = isNeutral
          ? const Color(0xFFFFC107)
          : isBullish
          ? const Color(0xFF00E676)
          : const Color(0xFFFF5252);

      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: LineChart(
          LineChartData(
            minX: max(0, candles.length - 30).toDouble(),
            maxX: candles.length.toDouble(),
            minY: minY * 0.998,
            maxY: maxY * 1.002,
            backgroundColor: Colors.transparent,
            clipData: const FlClipData.all(),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY - minY) / 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withValues(alpha: 0.05),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
                  interval: (maxY - minY) / 4,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(14),
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    return LineTooltipItem(
                      '₹${spot.y.toStringAsFixed(2)}',
                      TextStyle(
                        color: chartColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(candles.length, (index) {
                  final candle = candles[index];

                  return FlSpot(index.toDouble(), candle.close);
                }),
                isCurved: true,
                curveSmoothness: 0.22,
                preventCurveOverShooting: true,
                color: chartColor,
                gradient: LinearGradient(
                  colors: [chartColor, chartColor.withValues(alpha: 0.75)],
                ),
                barWidth: 3.5,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      chartColor.withValues(alpha: 0.32),
                      chartColor.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 250),
        ),
      );
    });
  }
}
