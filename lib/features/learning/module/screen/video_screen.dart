import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmc_project/features/learning/home/models/video_model.dart';
import 'package:lmc_project/features/learning/module/screen/widget/video_player.dart';
import 'package:lmc_project/features/utils/palette.dart';

import '../../../../main.dart';
import '../controllers/unified_player_controller.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.url, required this.videoData});
  final String url;
  final VideoModel videoData;
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedPlayerController());
    controller.loadVideoFromUrl(controller.videoUrl.value);
    return  Scaffold(
      backgroundColor: Colors.black,
    body:Container(
      padding: EdgeInsets.all(w * 0.02),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: h * 0.08,bottom: h * 0.03),
              child: Text(widget.videoData.title.toString(),style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                fontSize: h * 0.025
                  ,color: Palette.white
                  ),),
            ),
            UnifiedPlayerView(videoLInk: widget.url.toString(),),
          ],
        ),
      ),
    )
    );
  }
}
