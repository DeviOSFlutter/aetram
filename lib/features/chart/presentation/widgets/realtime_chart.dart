import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RealtimeChart extends GetView<ChartController> {
  const RealtimeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.chartPoints.isEmpty) {
        return const Center(child: Text('No chart data available'));
      }

      final points = controller.chartPoints;

      final List<double> prices = points.map((e) => e.y).toList();

      final double minY = prices.reduce((a, b) => a < b ? a : b) * 0.998;

      final double maxY = prices.reduce((a, b) => a > b ? a : b) * 1.002;

      final bool isPositive = prices.last >= prices.first;

      final Color chartColor = isPositive ? Colors.green : Colors.red;

      return LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          clipData: const FlClipData.all(),
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.15),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(12),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    '₹${spot.y.toStringAsFixed(2)}',
                    TextStyle(color: chartColor, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              curveSmoothness: 0.25,
              color: chartColor,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    chartColor.withValues(alpha: 0.35),
                    chartColor.withValues(alpha: 0.02),
                  ],
                ),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      );
    });
  }
}
