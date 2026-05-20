import 'package:aetram/core/network/dio_client.dart';
import 'package:aetram/core/storage/storage_service.dart';
import 'package:aetram/core/theme/theme_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(
      StorageService(),
      permanent: true,
    );

    Get.put<DioClient>(
      DioClient(),
      permanent: true,
    );

    Get.put<ThemeController>(
      ThemeController(
        Get.find<StorageService>(),
      ),
      permanent: true,
    );
  }
}