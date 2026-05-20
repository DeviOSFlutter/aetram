import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/core/theme/theme_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(
      () => StorageService(),
      fenix: true,
    );

    Get.lazyPut<ThemeController>(
      () => ThemeController(
        Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}