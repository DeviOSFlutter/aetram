import 'package:aetram/core/utils/app_sizes.dart';
import 'package:aetram/features/chart/domain/enums/chart_range.dart';
import 'package:aetram/features/chart/presentation/controllers/chart_controller.dart';
import 'package:aetram/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartHeroSection extends StatelessWidget {
  final String symbol;
  final double? ltp;
  final double? change;
  final double? changePercentage;
  final bool isPositive;
  final ChartController controller;

  const ChartHeroSection({
    super.key,
    required this.symbol,
    required this.ltp,
    required this.change,
    required this.changePercentage,
    required this.isPositive,
    required this.controller,
  });

  void _showBuySheet(BuildContext context, double currentLtp) {
    final qtyController = TextEditingController();
    final priceController = TextEditingController(text: currentLtp > 0 ? currentLtp.toStringAsFixed(2) : '');
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BUY $symbol',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                AppSizes.verticalSpaceMedium,
                TextFormField(
                  controller: qtyController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. 10',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity is required';
                    }
                    final qty = double.tryParse(value);
                    if (qty == null || qty <= 0) {
                      return 'Quantity must be greater than 0';
                    }
                    return null;
                  },
                ),
                AppSizes.verticalSpaceMedium,
                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Average Buy Price (₹)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. 1500.50',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    return null;
                  },
                ),
                AppSizes.verticalSpaceLarge,
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        final double qty = double.parse(qtyController.text);
                        final double price = double.parse(priceController.text);

                        final portfolioController = Get.find<PortfolioController>();
                        await portfolioController.buyHolding(
                          symbol: symbol,
                          quantity: qty,
                          averageBuyPrice: price,
                        );

                        Get.back();

                        Get.snackbar(
                          'Order Placed',
                          'Successfully bought $qty shares of $symbol at ₹${price.toStringAsFixed(2)}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT BUY ORDER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPositive
              ? [
                  Colors.green.withValues(alpha: 0.22),
                  Colors.green.withValues(alpha: 0.04),
                ]
              : [
                  Colors.red.withValues(alpha: 0.22),
                  Colors.red.withValues(alpha: 0.04),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSizes.verticalSpaceMedium,
          Text(
            ltp != null ? '₹${ltp!.toStringAsFixed(2)}' : '₹--',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSizes.verticalSpaceSmall,
          Obx(
            () => Text(
              controller.selectedRange.value == ChartRange.oneDay
                  ? 'Live Market Session'
                  : controller.selectedRange.value == ChartRange.oneWeek
                  ? '1 Week Historical'
                  : '1 Month Historical',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppSizes.verticalSpaceSmall,
          if (change != null && changePercentage != null)
            Text(
              '${change!.toStringAsFixed(2)} (${changePercentage!.toStringAsFixed(2)}%)',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          else
            Text(
              '-- (--%)',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          AppSizes.verticalSpaceMedium,
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                _showBuySheet(context, ltp ?? 0.0);
              },
              icon: const Icon(Icons.shopping_cart, size: 18),
              label: const Text(
                'BUY NOW',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
