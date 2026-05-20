import 'package:get/get.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 1.obs; // default: Watchlist tab

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
