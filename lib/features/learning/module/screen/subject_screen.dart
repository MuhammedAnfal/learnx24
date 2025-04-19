import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmc_project/features/learning/module/screen/video_screen.dart';

import '../../../../main.dart';
import '../../../utils/palette.dart';
import '../../home/models/subject_model.dart';
import '../controllers/module_controller.dart';
import '../controllers/unified_player_controller.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key, required this.subject});

  final SubjectModel subject;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  //-- variables
  final controller = Get.put(ModuleController());
  final videoController = Get.put(UnifiedPlayerController());
  List sortedModules= [];
  List  sortedVideos= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Palette.primaryColor, Colors.white.withOpacity(0.8)],
            ),
          ),
          padding: EdgeInsets.all(w * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Modules", style: GoogleFonts.poppins(fontSize: h * 0.025, fontWeight: FontWeight.w700)),
              SizedBox(height: h * 0.02),
              Obx(() {


                 sortedVideos = [...controller.videoLists]..sort((a, b) => a.id!.compareTo(b.id!));
                if (controller.isLoadingModules.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.moduleLists.isEmpty) {
                  return const Center(child: Text('No modules available'));
                }

                // Optional debug logs
                print("Modules: ${controller.moduleLists.length}");
                print("Videos: ${controller.videoLists.length}");

                return SizedBox(
                  height: h * 0.85,
                  width: w * 0.85,
                  child: ListView.builder(
                    itemCount: controller.moduleLists.length,
                    itemBuilder: (_, index) {
                      var module =controller.moduleLists[index];

                      // Safely access video
                      var moduleVideo = index < controller.videoLists.length ? sortedVideos[index] : null;

                      return GestureDetector(
                        onTap: () {
                          if (moduleVideo == null) {
                            Get.snackbar(
                              'Error',
                              'Video not found for this module',
                              snackPosition: SnackPosition.BOTTOM,
                              overlayColor: Colors.black87,
                            );
                            return;
                          }
                          print('object');
                          print(controller.videoLists[index].id);
                          print(controller.moduleId.value);
                          print('object');
                          controller.moduleId.value = index;
                          videoController.videoUrl.value = moduleVideo.videoUrl.toString();

                            Get.to(() => VideoScreen(videoData: moduleVideo, url: moduleVideo.videoUrl.toString()));

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: w * 0.02, top: h * 0.015, bottom: h * 0.03),
                          padding: EdgeInsets.all(w * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 15, offset: Offset(0, 0))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${module.id}. ${module.title}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: h * 0.02),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: w * 0.01, top: h * 0.01),
                                child: Text('${module.description}', style: GoogleFonts.poppins(fontSize: h * 0.017)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
