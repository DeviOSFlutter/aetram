import 'package:flutter/material.dart';

class TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
