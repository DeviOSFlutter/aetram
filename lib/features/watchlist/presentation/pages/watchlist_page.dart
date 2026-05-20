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
          automaticallyImplyLeading: false,
          title: const Text(AppStrings.watchlistTitle),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.symbolSearch);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.watchlist.isEmpty) {
            return const Center(child: Text(AppStrings.emptyWatchlist));
          }
      
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            itemCount: controller.watchlist.length,
            separatorBuilder: (_, _) => AppSizes.verticalSpaceSmall,
            itemBuilder: (context, index) {
              final item = controller.watchlist[index];
      
              return Card(
                child: ListTile(
                  title: Text(
                    item.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.removeSymbol(item.symbol);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed(AppRoutes.symbolSearch);
          },
          icon: const Icon(Icons.add),
          label: const Text(AppStrings.addSymbols),
        ),
      ),
    );
  }
}
