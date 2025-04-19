import 'package:get/get.dart';

import '../data/repositories/home_repository.dart';
import '../features/learning/home/controllers/home_controller.dart';

class GeneralBiniding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeRepository());
    Get.lazyPut(() => HomeController());
  }
}
