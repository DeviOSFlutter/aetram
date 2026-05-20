import 'package:aetram/features/chart/presentation/widgets/candle_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullscreenChartPage extends StatefulWidget {
  const FullscreenChartPage({super.key});

  @override
  State<FullscreenChartPage> createState() => _FullscreenChartPageState();
}

class _FullscreenChartPageState extends State<FullscreenChartPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              const CandleChart(),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
