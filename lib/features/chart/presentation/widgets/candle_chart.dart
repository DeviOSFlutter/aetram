import 'dart:math';

import 'package:aetram/core/utils/format_utils.dart';
import 'package:aetram/features/chart/domain/entities/candle_entity.dart';
import 'package:aetram/features/chart/domain/enums/chart_range.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/shared/widgets/app_loader.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _CandleChartController extends GetxController {
  final viewportWidth = Rxn<double>();
  final scrollOffset = 0.0.obs;

  double dragStartScrollOffset = 0.0;
  double scaleStartViewportWidth = 30.0;
  Offset scaleStartFocalPoint = Offset.zero;

  ChartRange? lastRange;
  String? lastSymbol;

  void resetView() {
    viewportWidth.value = null;
    scrollOffset.value = 0.0;
  }
}

class CandleChart extends StatelessWidget {
  const CandleChart({super.key});

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();
    final state = Get.put(_CandleChartController());

    return Obx(() {
      if (chartController.isLoading.value) {
        return const AppLoader();
      }

      final candles = chartController.candles;

      if (candles.isEmpty) {
        if (chartController.selectedRange.value == ChartRange.oneDay) {
          return const Center(child: Text('Waiting for live market data...'));
        } else {
          return const Center(
            child: Text('No historical data available for this symbol'),
          );
        }
      }

      final range = chartController.selectedRange.value;
      final symbol = chartController.selectedSymbol.value;

      // Automatically reset zoom and pan on range or symbol change
      if (state.lastRange != range || state.lastSymbol != symbol) {
        state.lastRange = range;
        state.lastSymbol = symbol;
        state.viewportWidth.value = null;
        state.scrollOffset.value = 0.0;
      }

      final double totalLength = candles.length.toDouble();
      final double defaultWidth =
          (range == ChartRange.oneDay) ? min(30.0, totalLength) : totalLength;

      double vw = state.viewportWidth.value ?? defaultWidth;
      // Clamp viewportWidth to be between 5.0 and the total length
      vw = vw.clamp(5.0, max(5.0, totalLength));

      // Clamp scrollOffset to be between 0.0 and (totalLength - viewportWidth)
      final double maxScroll = max(0.0, totalLength - vw);
      state.scrollOffset.value = state.scrollOffset.value.clamp(0.0, maxScroll);

      double maxX = totalLength - 1.0 - state.scrollOffset.value;
      double minX = maxX - vw + 1.0;

      // Ensure minX does not drop below 0.0
      if (minX < 0.0) {
        minX = 0.0;
        maxX = minX + vw - 1.0;
      }

      // Calculate indices for visible subset of candles to scale Y-axis dynamically
      final int startIdx = max(0, minX.floor());
      final int endIdx = min(candles.length - 1, maxX.ceil());

      final List<CandleEntity> visibleCandles =
          (startIdx <= endIdx && startIdx < candles.length)
              ? candles.sublist(startIdx, endIdx + 1)
              : candles;

      final List<double> highs = visibleCandles.map((e) => e.high).toList();
      final List<double> lows = visibleCandles.map((e) => e.low).toList();

      double maxY = highs.isNotEmpty ? highs.reduce(max) : 1.0;
      double minY = lows.isNotEmpty ? lows.reduce(min) : 0.0;

      if ((maxY - minY).abs() < 0.1) {
        if (maxY == 0) {
          maxY = 1.0;
          minY = -1.0;
        } else {
          maxY = maxY + 0.5;
          minY = minY - 0.5;
        }
      }

      final CandleEntity latest = candles.last;
      final bool isBullish = latest.close > latest.open;
      final bool isNeutral = (latest.close - latest.open).abs() < 0.15;

      final Color chartColor = isNeutral
          ? const Color(0xFFFFC107)
          : isBullish
          ? const Color(0xFF00E676)
          : const Color(0xFFFF5252);

      return Stack(
        children: [
          GestureDetector(
            onScaleStart: (details) {
              state.dragStartScrollOffset = state.scrollOffset.value;
              state.scaleStartViewportWidth = state.viewportWidth.value ?? defaultWidth;
              state.scaleStartFocalPoint = details.focalPoint;
            },
            onScaleUpdate: (details) {
              if (details.scale != 1.0) {
                final double newWidth = state.scaleStartViewportWidth / details.scale;
                state.viewportWidth.value = newWidth.clamp(5.0, max(5.0, totalLength));
              }

              final double deltaX = details.focalPoint.dx - state.scaleStartFocalPoint.dx;
              // pixelToSpotRatio maps how many candles correspond to 1 pixel of movement.
              // Assuming a typical viewport layout width of around 350.0 pixels
              final double pixelToSpotRatio = vw / 350.0;

              final double currentWidth = state.viewportWidth.value ?? defaultWidth;
              final double currentMaxScroll = max(0.0, totalLength - currentWidth);
              state.scrollOffset.value =
                  (state.dragStartScrollOffset + (deltaX * pixelToSpotRatio))
                      .clamp(0.0, currentMaxScroll);
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
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
                            FormatUtils.formatCurrency(spot.y),
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
                      isCurved: candles.length >= 2,
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
            ),
          ),
          if (state.viewportWidth.value != null || state.scrollOffset.value > 0.0)
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton.icon(
                onPressed: state.resetView,
                icon: const Icon(Icons.zoom_out_map, size: 14),
                label: const Text('Reset View', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.7),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ],
      );
    });
  }
}
