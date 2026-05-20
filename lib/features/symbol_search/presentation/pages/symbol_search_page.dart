import 'package:aetram/core/constants/app_strings.dart';
import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/symbol_search/presentation/controllers/symbol_search_controller.dart';
import 'package:aetram/features/symbol_search/presentation/widgets/symbol_tile.dart';
import 'package:aetram/shared/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymbolSearchPage extends GetView<SymbolSearchController> {
  const SymbolSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.symbolSearchTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            TextField(
              controller: controller.searchController,
              onChanged: controller.filterSymbols,
              decoration: const InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            AppSizes.verticalSpaceMedium,
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const AppLoader();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                if (controller.filteredSymbols.isEmpty) {
                  return const Center(child: Text(AppStrings.noSymbolsFound));
                }

                return ListView.separated(
                  itemCount: controller.filteredSymbols.length,
                  separatorBuilder: (_, _) => AppSizes.verticalSpaceSmall,
                  itemBuilder: (context, index) {
                    return SymbolTile(
                      symbol: controller.filteredSymbols[index],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
