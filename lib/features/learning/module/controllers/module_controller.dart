
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../data/repositories/module_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/models/video_model.dart';
import '../models/module_model.dart';

enum VideoSourceType { direct, youtube, vimeo, unsupported }

class ModuleController extends GetxController {
  static ModuleController get instance => Get.find();
  //-- variables
  RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();
  RxInt carouselindex = 0.obs;
  RxBool isLoadingModules = true.obs;
  RxBool isLoadingVideos = true.obs;
  RxList<ModuleModel> moduleLists = <ModuleModel>[].obs;
  RxList<VideoModel> videoLists = <VideoModel>[].obs;
  final repository = Get.put(ModuleRepository());
  final controller = Get.put(HomeController());
  RxInt moduleId = 0.obs;

  
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getModules(subjectid: controller.selectedSubjectId.value);
    getVideos(subjectid: moduleId.toInt());
  }

  Future<void> getModules({required int subjectid}) async {
    try {
      isLoadingModules(true);
      final modules = await repository.getModules(subjectId: subjectid);
      moduleLists.assignAll(modules);
    } catch (e) {
      Get.snackbar('Oh snap!', e.toString());
    } finally {
      isLoadingModules.value = false;
    }
  }

  Future<void> getVideos({required int subjectid}) async {
    try {

      isLoadingVideos(true);
      final videos = await repository.getVideos(subjectId: subjectid);
      videoLists.assignAll(videos);
    } catch (e) {
      Get.snackbar('Oh snap!', e.toString());
    } finally {
      isLoadingVideos.value = false;
    }
  }

 }
