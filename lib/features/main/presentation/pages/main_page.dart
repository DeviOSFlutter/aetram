import 'package:aetram/features/about/presentation/pages/about_page.dart';
import 'package:aetram/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:aetram/features/main/presentation/controllers/main_controller.dart';
import 'package:aetram/features/main/presentation/widgets/tab_item.dart';
import 'package:aetram/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:aetram/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  static const double _railBreakpoint = 600.0;

  static const List<TabItem> _tabs = [
    TabItem(
      label: 'Dashboard',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics_rounded,
    ),
    TabItem(
      label: 'Watchlist',
      icon: Icons.remove_red_eye_outlined,
      activeIcon: Icons.remove_red_eye,
    ),
    TabItem(
      label: 'Portfolio',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
    ),
    TabItem(
      label: 'About',
      icon: Icons.info_outline_rounded,
      activeIcon: Icons.info_rounded,
    ),
  ];

  static const List<Widget> _pages = [
    DashboardPage(),
    WatchlistPage(),
    PortfolioPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= _railBreakpoint;
          return isWide ? _buildWideLayout() : _buildMobileLayout();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Obx(() {
      final int idx = controller.currentIndex.value;
      return Scaffold(
        body: IndexedStack(index: idx, children: _pages),
        bottomNavigationBar: _buildBottomNav(idx),
      );
    });
  }

  Widget _buildBottomNav(int currentIdx) {
    return NavigationBar(
      selectedIndex: currentIdx,
      onDestinationSelected: controller.changeTab,
      destinations: _tabs.map((tab) {
        return NavigationDestination(
          icon: Icon(tab.icon),
          selectedIcon: Icon(tab.activeIcon),
          label: tab.label,
        );
      }).toList(),
    );
  }

  Widget _buildWideLayout() {
    return Obx(() {
      final int idx = controller.currentIndex.value;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: idx,
              onDestinationSelected: controller.changeTab,
              labelType: NavigationRailLabelType.all,
              destinations: _tabs.map((tab) {
                return NavigationRailDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.activeIcon),
                  label: Text(tab.label),
                );
              }).toList(),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: IndexedStack(index: idx, children: _pages),
            ),
          ],
        ),
      );
    });
  }
}
