import 'package:get/get.dart';
import 'package:dpp/app/modules/home/controllers/search_controller.dart';
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}