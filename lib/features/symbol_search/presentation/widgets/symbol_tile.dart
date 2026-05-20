import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:aetram/features/watchlist/presentation/controllers/watchlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymbolTile extends GetView<WatchlistController> {
  final SymbolEntity symbol;

  const SymbolTile({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          final bool exists = controller.watchlist.any(
            (item) => item.symbol == symbol.symbol,
          );
          if (exists) {
            controller.removeSymbol(symbol.symbol);
          } else {
            controller.addSymbol(symbol.symbol);
          }
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        title: Text(
          symbol.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(symbol.name),
        trailing: Obx(() {
          final bool exists = controller.watchlist.any(
            (item) => item.symbol == symbol.symbol,
          );

          return IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (exists) {
                controller.removeSymbol(symbol.symbol);
              } else {
                controller.addSymbol(symbol.symbol);
              }
            },
            icon: Icon(exists ? Icons.bookmark : Icons.bookmark_border),
          );
        }),
      ),
    );
  }
}
