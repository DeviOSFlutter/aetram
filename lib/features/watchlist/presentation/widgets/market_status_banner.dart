import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/socket/socket_status.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketStatusBanner extends GetView<WatchlistController> {
  const MarketStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.connectionStatus.value;

      final bool isConnected = status == SocketStatus.connected;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isConnected
              ? Colors.green.withValues(alpha: 0.12)
              : Colors.red.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: isConnected ? Colors.green : Colors.red,
            ),
            AppSizes.horizontalSpaceSmall,
            Expanded(
              child: Text(
                isConnected ? AppStrings.liveMarket : AppStrings.reconnecting,
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
