import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String themeKey = 'isDarkMode';

  final GetStorage _box = GetStorage();

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _box.write(themeKey, isDarkMode);
  }

  bool getThemeMode() {
    return _box.read(themeKey) ?? false;
  }
}