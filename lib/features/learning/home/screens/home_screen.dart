import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmc_project/features/learning/home/screens/widgets/home_carousel.dart';
import 'package:lmc_project/features/utils/palette.dart';

import '../../../../main.dart';
import '../../../utils/constants/image_constants.dart';
import '../../module/screen/subject_screen.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(w * 0.02),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Palette.primaryColor, Colors.white.withOpacity(0.8)])),
          child: SingleChildScrollView(
            child: Column(

              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:  EdgeInsets.only(top: h * 0.02,left: w * 0.02),
                    child: Text('Welcome To LearnX24',
                      style:GoogleFonts.poppins(
                        fontSize: h * 0.023,
                        fontWeight: FontWeight.w600
                      )),

                  ),
                ),
                HomeCarousel(
                  margin: EdgeInsets.only(top: h * 0.02, right: w * 0.01, left: w * 0.01),
                  banners: const [ImageConstants.carouselImage1, ImageConstants.carouselImage2, ImageConstants.carouselImage3],
                ),
                Container(
                  height: h * 0.6,
                  width: w * 0.9,
                  margin: EdgeInsets.only(top: h * 0.02),
                  padding: EdgeInsets.all(w * 0.02),
                  child: Obx(() {
                    if (controller.isLoadingSubjects.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (controller.subjectsList.isEmpty) {
                      return const Center(child: Text('No subjects available'));
                    }
                    return ListView.builder(
                      itemCount: controller.subjectsList.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        var subject = controller.subjectsList[index];
                        return GestureDetector(
                          onTap: () {
                            controller.selectedSubjectId.value = subject.id?.toInt() ?? 0;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubjectScreen(subject: subject),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(w * 0.02),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black87,
                                blurStyle: BlurStyle.outer,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)
                                )
                              ],
                              border: Border.all(strokeAlign: 1,color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            margin: EdgeInsets.only(left: w * 0.02, top: h * 0.015),
                            // height: h * 0.1,
                            width: w * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(top: h * 0.01,bottom: h * 0.02),
                                  child: Container(

                                    padding: EdgeInsets.symmetric(horizontal:w * 0.035,vertical: h * 0.008),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Text(subject.title.toString(),style: GoogleFonts.poppins(
                                      fontSize: h * 0.025,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                  ),
                                ),

                                ClipRRect(
                                   borderRadius: BorderRadius.circular(15),
                                    child: Image.network(subject.image.toString(),height: h * 0.2,)),
                                Padding(
                                  padding:  EdgeInsets.only(left: w * 0.04,top: h * 0.02),
                                  child: Text(subject.description.toString(),style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: h * 0.017
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
