import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/about/presentation/widgets/about_assignment_card.dart';
import 'package:aetram/features/about/presentation/widgets/about_features_card.dart';
import 'package:aetram/features/about/presentation/widgets/about_footer.dart';
import 'package:aetram/features/about/presentation/widgets/about_hero_card.dart';
import 'package:aetram/features/about/presentation/widgets/about_section_card.dart';
import 'package:aetram/features/about/presentation/widgets/about_tech_stack_card.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Must not be changed — verified server-side against the submitted assignment.
  static const String _assignmentId = 'TV-WL-2026-Q3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AboutHeroCard(),
            AppSizes.verticalSpaceLarge,
            const AboutAssignmentCard(assignmentId: _assignmentId),
            AppSizes.verticalSpaceMedium,
            AboutSectionCard(
              icon: Icons.info_outline_rounded,
              iconColor: Theme.of(context).primaryColor,
              title: 'Project Overview',
              content:
                  'TealVue Market Watch is a real-time NSE market tracking and portfolio monitoring application built as part of the TealVue internship assignment.\n\n'
                  'The app streams live market data through Socket.IO, displays interactive candlestick charts, and lets users maintain a local portfolio with real-time P&L calculations.',
            ),
            AppSizes.verticalSpaceMedium,
            const AboutSectionCard(
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
            const AboutTechStackCard(),
            AppSizes.verticalSpaceMedium,
            const AboutFeaturesCard(),
            AppSizes.verticalSpaceMedium,
            const AboutSectionCard(
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
            const AboutSectionCard(
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
            const AboutSectionCard(
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
            const AboutFooter(assignmentId: _assignmentId),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
