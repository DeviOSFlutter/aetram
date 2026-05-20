import 'package:aetram/core/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Must not be changed — verified server-side against the submitted assignment.
  static const String _assignmentId = 'TV-WL-2026-Q3';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(isDark),
            AppSizes.verticalSpaceMedium,
            _buildAssignmentCard(context, isDark),
            AppSizes.verticalSpaceMedium,
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.info_outline_rounded,
              iconColor: Colors.blue,
              title: 'Project Overview',
              content:
                  'TealVue Market Watch is a real-time NSE market tracking and portfolio monitoring application built as part of the TealVue internship assignment.\n\n'
                  'The app streams live market data through Socket.IO, displays interactive candlestick charts, and lets users maintain a local portfolio with real-time P&L calculations.',
            ),
            AppSizes.verticalSpaceMedium,
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.architecture_rounded,
              iconColor: Colors.deepPurple,
              title: 'Architecture',
              content:
                  'Built with Strict Clean Architecture following the flow:\n\n'
                  'Presentation  →  Use Case  →  Repository  →  Data Source\n\n'
                  '• Feature-first folder structure\n'
                  '• GetX for state management & dependency injection\n'
                  '• Bindings wired per feature module\n'
                  '• No business logic in widgets or controllers\n'
                  '• Repository contracts with implementation separation',
            ),
            AppSizes.verticalSpaceMedium,
            _buildTechStackCard(isDark),
            AppSizes.verticalSpaceMedium,
            _buildFeaturesCard(isDark),
            AppSizes.verticalSpaceMedium,
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.wifi_rounded,
              iconColor: Colors.teal,
              title: 'WebSocket & Realtime Engine',
              content:
                  'Live market ticks are streamed via Socket.IO from the TealVue market data server.\n\n'
                  '• SocketService wraps socket_io_client and exposes a reactive tickerStream\n'
                  '• WatchlistController subscribes/unsubscribes to symbol topics\n'
                  '• Portfolio and chart symbols are auto-added to subscriptions\n'
                  '• Ticker bursts are processed into 5-second candle buckets\n'
                  '• IndexedStack preserves WebSocket state across tab navigation',
            ),
            AppSizes.verticalSpaceMedium,
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.candlestick_chart_rounded,
              iconColor: Colors.orange,
              title: 'Chart System',
              content:
                  'Interactive candlestick charts powered by fl_chart:\n\n'
                  '• 1D live mode: real-time candles bucketed at 5-second intervals\n'
                  '• 1W / 1M historical: fetched from REST API and cached\n'
                  '• Smooth pan & pinch-to-zoom gestures with focal-point tracking\n'
                  '• Trading-style green/red gradient fills\n'
                  '• Fullscreen landscape mode via SystemChrome orientation lock\n'
                  '• Persistent candle cache across navigation',
            ),
            AppSizes.verticalSpaceMedium,
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.devices_rounded,
              iconColor: Colors.indigo,
              title: 'Responsive Design',
              content:
                  'The app adapts to any screen size using LayoutBuilder breakpoints:\n\n'
                  '• Mobile: BottomNavigationBar tab switching\n'
                  '• Tablet / Desktop: NavigationRail side navigation\n'
                  '• IndexedStack preserves each tab\'s state independently',
            ),
            AppSizes.verticalSpaceMedium,
            _buildFooter(isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
              : [const Color(0xFF00695C), const Color(0xFF004D40)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.show_chart_rounded,
                  size: 40, color: Colors.white),
            ),
            AppSizes.horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TealVue',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Market Watch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Real-time NSE trading companion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: Colors.teal.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.badge_outlined, color: Colors.teal, size: 22),
            ),
            AppSizes.horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assignment Identifier',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    _assignmentId,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Copy ID',
              icon: const Icon(Icons.copy_rounded, size: 18),
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: _assignmentId));
                Get.snackbar(
                  'Copied',
                  _assignmentId,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechStackCard(bool isDark) {
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

    return _buildCard(
      isDark: isDark,
      icon: Icons.code_rounded,
      iconColor: Colors.blue,
      title: 'Technology Stack',
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

  Widget _buildFeaturesCard(bool isDark) {
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

    return _buildCard(
      isDark: isDark,
      icon: Icons.star_rounded,
      iconColor: Colors.amber,
      title: 'Features',
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
                    child:
                        Icon(f['icon'] as IconData, size: 18, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          f['sub'] as String,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
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

  Widget _buildFooter(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.07),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            Text(
              'TealVue Market Watch',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Assignment $_assignmentId  ·  Flutter + Clean Architecture',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return _buildCard(
      isDark: isDark,
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

  Widget _buildCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
