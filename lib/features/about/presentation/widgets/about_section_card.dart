import 'package:aetram/features/about/presentation/widgets/about_card_frame.dart';
import 'package:flutter/material.dart';

class AboutSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;

  const AboutSectionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AboutCardFrame(
      icon: icon,
      iconColor: iconColor,
      title: title,
      child: Text(
        content,
        style: TextStyle(
          fontSize: 13,
          height: 1.6,
          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
    );
  }
}
