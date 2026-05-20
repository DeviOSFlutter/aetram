import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/core/utils/format_utils.dart';
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

      return Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: () {
            Get.toNamed(AppRoutes.chart, arguments: item.symbol);
          },
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
                  child: Text(AppStrings.waitingForRealtime),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Text(
                        FormatUtils.formatCurrency(tick.ltp),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${FormatUtils.formatCurrency(tick.change, includeSign: true)} (${FormatUtils.formatPercentage(tick.changePercentage, includeSign: true)})',
                        style: TextStyle(
                          color: FormatUtils.getPnLRawColor(tick.change),
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
