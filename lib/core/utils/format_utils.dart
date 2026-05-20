import 'package:flutter/material.dart';

class FormatUtils {
  /// Consistent positive and negative colors for P&L tracking.
  static const Color positiveColor = Color(0xFF00E676);
  static const Color negativeColor = Color(0xFFFF5252);

  /// Consistent positive and negative raw colors for standard list tiles.
  static const Color positiveRawColor = Colors.green;
  static const Color negativeRawColor = Colors.red;

  /// Formats currency with ₹ symbol and 2 decimal places.
  /// Example: 12500.5 -> "₹12500.50"
  /// If [includeSign] is true and value is positive, adds '+' sign.
  static String formatCurrency(double value, {bool includeSign = false}) {
    if (value.isNegative) {
      return '-₹${value.abs().toStringAsFixed(2)}';
    }
    final String sign = includeSign && value > 0 ? '+' : '';
    return '$sign₹${value.toStringAsFixed(2)}';
  }

  /// Formats percentage value with % symbol and 2 decimal places.
  /// Example: 2.456 -> "+2.46%" or "-2.46%"
  /// If [includeSign] is true and value is positive, adds '+' sign.
  static String formatPercentage(double value, {bool includeSign = true}) {
    if (value.isNegative) {
      return '-${value.abs().toStringAsFixed(2)}%';
    }
    final String sign = includeSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Returns positive/negative sign.
  static String getSign(double value) {
    return value >= 0 ? '+' : '';
  }

  /// Consistent positive/negative colors.
  static Color getPnLColor(double value) {
    return value >= 0 ? positiveColor : negativeColor;
  }

  /// Consistent positive/negative raw colors (e.g., standard green/red).
  static Color getPnLRawColor(double value) {
    return value >= 0 ? positiveRawColor : negativeRawColor;
  }
}
