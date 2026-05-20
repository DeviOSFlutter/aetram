import 'package:aetram/core/storage/storage_keys.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _box.write(StorageKeys.themeMode, isDarkMode);
  }

  bool getThemeMode() {
    return _box.read(StorageKeys.themeMode) ?? false;
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }
}
