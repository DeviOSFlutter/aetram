import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/features/about/presentation/widgets/about_card_frame.dart';
import 'package:flutter/material.dart';

class AboutFeaturesCard extends StatelessWidget {
  const AboutFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final features = [
      {
        'icon': Icons.visibility_rounded,
        'color': Colors.blue,
        'title': 'Realtime Watchlist',
        'sub': 'Live LTP, % change & socket ticks',
      },
      {
        'icon': Icons.candlestick_chart_rounded,
        'color': Colors.orange,
        'title': 'Realtime Charts',
        'sub': 'Live 1D candles bucketed at 5s intervals',
      },
      {
        'icon': Icons.history_rounded,
        'color': Colors.purple,
        'title': 'Historical Ranges',
        'sub': '1W & 1M OHLC via REST API',
      },
      {
        'icon': Icons.fullscreen_rounded,
        'color': Colors.indigo,
        'title': 'Fullscreen Chart',
        'sub': 'Landscape lock with pan & zoom gestures',
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'color': Colors.green,
        'title': 'Portfolio Tracking',
        'sub': 'Local holdings with realtime P&L',
      },
      {
        'icon': Icons.analytics_rounded,
        'color': Colors.teal,
        'title': 'Dashboard Analytics',
        'sub': 'Gainer, loser, VWAP comparison',
      },
    ];

    return AboutCardFrame(
      icon: Icons.star_rounded,
      iconColor: Colors.amber,
      title: AppStrings.features,
      child: Column(
        children: features.asMap().entries.map((entry) {
          final f = entry.value;
          final Color color = f['color'] as Color;
          final bool isLast = entry.key == features.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(f['icon'] as IconData, size: 18, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          f['sub'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}
