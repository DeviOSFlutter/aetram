import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/symbol_search/domain/entities/symbol_entity.dart';
import 'package:flutter/material.dart';

class SymbolTile extends StatelessWidget {
  final SymbolEntity symbol;

  const SymbolTile({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        title: Text(
          symbol.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(symbol.name),
        trailing: Text(symbol.exchange),
      ),
    );
  }
}
