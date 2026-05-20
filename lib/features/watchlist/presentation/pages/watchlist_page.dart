import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchlistPage extends GetView<WatchlistController> {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.watchlistTitle),
          actions: [
            Obx(() {
              if (controller.watchlist.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.symbolSearch);
                },
                icon: const Icon(Icons.add),
              );
            }),
          ],
        ),
        body: Obx(() {
          if (controller.watchlist.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.emptyWatchlist,
                      textAlign: TextAlign.center,
                    ),
                    AppSizes.verticalSpaceMedium,
                    SizedBox(
                      width: 220,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.symbolSearch);
                        },
                        child: const Text(AppStrings.addSymbols),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            itemCount: controller.watchlist.length,
            separatorBuilder: (_, _) => AppSizes.verticalSpaceSmall,
            itemBuilder: (context, index) {
              final item = controller.watchlist[index];

              return Obx(() {
                final tick = controller.getTick(item.symbol);

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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${tick.change.toStringAsFixed(2)} (${tick.changePercentage.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                    color: isPositive
                                        ? Colors.green
                                        : Colors.red,
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
            },
          );
        }),
      ),
    );
  }
}
