import 'package:get/get.dart';
import 'package:dpp/legacy/search_controller.dart';
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}