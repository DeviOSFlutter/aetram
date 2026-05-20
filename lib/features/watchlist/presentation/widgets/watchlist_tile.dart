import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/watchlist/domain/entities/tick_entity.dart';
import 'package:aetram/features/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchlistTile extends GetView<WatchlistController> {
  final WatchlistItemEntity item;

  const WatchlistTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TickEntity? tick = controller.getTick(item.symbol);

      final bool isPositive = (tick?.change ?? 0) >= 0;

      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall,
          ),
          title: Text(
            item.symbol,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: tick == null
              ? const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('Waiting for realtime data...'),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Text(
                        '₹${tick.ltp.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${tick.change.toStringAsFixed(2)} (${tick.changePercentage.toStringAsFixed(2)}%)',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
          trailing: IconButton(
            onPressed: () {
              controller.removeSymbol(item.symbol);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ),
      );
    });
  }
}
