import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../main.dart';
import '../../../utils/constants/image_constants.dart';
import '../../../utils/palette.dart';
import '../controllers/home_controller.dart';
import 'home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // 🔧 Use `const` constructor

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //-- variables
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  void dispose() {
    _btnController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.put(HomeController());
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          SvgPicture.asset(
            ImageConstants.splahsImage,
            height: h,
            width: w,
            fit: BoxFit.cover,
          ),

          /// Motivational Text
          Positioned(
            bottom: h * 0.13,
            left: w * 0.068,
            child: Text(
              "Your journey to mastering new\n             skills starts here",
              style: GoogleFonts.poppins(
                fontSize: h * 0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// Get Started Button
          Positioned(
            bottom: h * 0.05,
            left: w * 0.25,
            child: SizedBox(
              width: w * 0.48,
              child: RoundedLoadingButton(
                controller: homecontroller.buttonController,
                resetDuration: const Duration(seconds: 2),
                color: Palette.primaryColor,
                successColor: Colors.green,
                onPressed: () {
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.off(()=>HomeScreen());
                    homecontroller.buttonController.stop();
                  });
                },
                child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: h * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
