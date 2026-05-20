import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/routes/app_routes.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:aetram/features/watchlist/presentation/widgets/market_status_banner.dart';
import 'package:aetram/features/watchlist/presentation/widgets/watchlist_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchlistPage extends GetView<WatchlistController> {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.paddingMedium,
                  AppSizes.paddingMedium,
                  AppSizes.paddingMedium,
                  0,
                ),
                child: MarketStatusBanner(),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  itemCount: controller.watchlist.length,
                  separatorBuilder: (_, _) => AppSizes.verticalSpaceSmall,
                  itemBuilder: (context, index) {
                    final item = controller.watchlist[index];

                    return WatchlistTile(item: item);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
