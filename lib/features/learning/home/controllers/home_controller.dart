import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../data/repositories/home_repository.dart';
import '../models/subject_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  //-- variables
  RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();
  RxInt carouselindex = 0.obs;
  RxBool isLoadingSubjects = true.obs;
  RxList<SubjectModel> subjectsList = <SubjectModel>[].obs;
  final repository = Get.put(HomeRepository());
  RxInt selectedSubjectId = 0.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getSubjects();
  }

  Future<void> getSubjects() async {
    try {
      isLoadingSubjects(true);
      final subjects = await repository.getSubjects();
      subjectsList.assignAll(subjects);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Oh snap!', e.toString());
    } finally {
      isLoadingSubjects.value = false;
    }
  }


}
