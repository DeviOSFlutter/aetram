import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/features/about/presentation/widgets/about_card_frame.dart';
import 'package:flutter/material.dart';

class AboutTechStackCard extends StatelessWidget {
  const AboutTechStackCard({super.key});

  @override
  Widget build(BuildContext context) {
    final techs = [
      {'name': 'Flutter', 'icon': Icons.flutter_dash, 'color': Colors.blue},
      {'name': 'GetX', 'icon': Icons.bolt_rounded, 'color': Colors.amber},
      {'name': 'Dio', 'icon': Icons.http_rounded, 'color': Colors.purple},
      {
        'name': 'Socket.IO',
        'icon': Icons.wifi_tethering_rounded,
        'color': Colors.teal,
      },
      {
        'name': 'GetStorage',
        'icon': Icons.storage_rounded,
        'color': Colors.green,
      },
      {
        'name': 'fl_chart',
        'icon': Icons.candlestick_chart_rounded,
        'color': Colors.orange,
      },
    ];

    return AboutCardFrame(
      icon: Icons.code_rounded,
      iconColor: Theme.of(context).primaryColor,
      title: AppStrings.technologyStack,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: techs.map((tech) {
          final Color color = tech['color'] as Color;
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tech['icon'] as IconData, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  tech['name'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
