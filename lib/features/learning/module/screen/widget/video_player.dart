
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmc_project/features/utils/palette.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../main.dart';
import '../../controllers/unified_player_controller.dart';

class UnifiedPlayerView extends StatelessWidget {
  final UnifiedPlayerController controller = Get.find();
final String videoLInk;
   UnifiedPlayerView({super.key, required this.videoLInk});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedPlayerController());
    return Obx(() {
      // Show loading indicator
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      // Show error message
      if (controller.errorMessage.value.isNotEmpty) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.error_outline, color: Colors.red, size: h * 0.07 ),
                 SizedBox(height: h * 0.02),
                Text('Sorry\nVideo not found' ,style: GoogleFonts.poppins(
                  fontSize: h * 0.018,
                  fontWeight: FontWeight.w600,color: Palette.buttonColors,
                ), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }

      if (controller.videoSource.value == VideoSource.none) {
        return  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: h * 0.08, color: Colors.grey),
              SizedBox(height: h * 0.02),
              Text('Sorry\nVideo not found' ,style: GoogleFonts.poppins(
                  fontSize: h * 0.018,
                  fontWeight: FontWeight.w600
                  ,color: Palette.buttonColors,
              ), textAlign: TextAlign.center),
            ],
          ),
        );
      }
      
      //  YouTube player
      if (controller.videoSource.value == VideoSource.youtube && 
          controller.youtubeController != null) {
        return Column(
          children: [
            // YouTube player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: controller.youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
              ),
            ),
            // Info and custom controls
            _buildControls(context),
          ],
        );
      }
      
      //  Vimeo player
      if (controller.videoSource.value == VideoSource.vimeo && 
          controller.vimeoVideoController != null &&
          controller.chewieController != null) {
        return Column(
          children: [
            // Vimeo player
            AspectRatio(
              aspectRatio: controller.vimeoVideoController!.value.aspectRatio,
              child: Chewie(controller: controller.chewieController!),
            ),
            // Info and custom controls
            _buildControls(context),
          ],
        );
      }
      

      return const Center(child: Text('Loading video...'));
    });
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(w * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video title
          Text(
            controller.videoTitle.value,
            style:  TextStyle(fontSize: h * 0.02, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
           SizedBox(height: h * 0.02),
          
          //  playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon:  Icon(Icons.replay_10,size: h * 0.045,color: Palette.buttonColors,),
                onPressed: controller.rewind10Seconds,
                tooltip: 'Rewind 10 seconds',
              ),
              IconButton(
                icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow,size: h * 0.045,color: Palette.buttonColors,),
                onPressed: controller.playPause,
                tooltip: controller.isPlaying.value ? 'Pause' : 'Play',
              ),
              IconButton(
                icon:  Icon(Icons.forward_10,size: h * 0.045,color: Palette.buttonColors,),
                onPressed: controller.forward10Seconds,
                tooltip: 'Forward 10 seconds',
              ),
              IconButton(
                icon: Icon(controller.isMuted.value ? Icons.volume_off : Icons.volume_up,size: h * 0.045,color: Palette.buttonColors,),
                onPressed: controller.toggleMute,
                tooltip: controller.isMuted.value ? 'Unmute' : 'Mute',
              ),
            ],
          ),
          
          // Progress bar
          Obx(() => controller.duration.value > 0 ? Row(
            children: [
              Text(_formatDuration(controller.currentPosition.value,),style: GoogleFonts.poppins(
                fontSize: h * 0.017,color: Palette.buttonColors,
              ),),
              Expanded(
                child: Slider(
                  activeColor: Palette.primaryColor,
                  inactiveColor: Palette.darkGrey,
                  value: controller.currentPosition.value.clamp(0, controller.duration.value),
                  min: 0,
                  max: controller.duration.value,
                  onChanged: (value) {
                    controller.seekTo(value);
                  },
                ),
              ),
              Text(_formatDuration(controller.duration.value),style: GoogleFonts.poppins(
                fontSize: h * 0.017,color: Palette.buttonColors,
              ),),
            ],
          ) : Container()),
          
          // Volume control
          Row(
            children: [
               Icon(Icons.volume_down, size: h * 0.045,color: Palette.buttonColors,),
              Expanded(
                child: Slider(
                  activeColor: Palette.primaryColor,
                  inactiveColor: Palette.darkGrey,
                  value: controller.volume.value,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    controller.setVolume(value);
                  },
                ),
              ),
               Icon(Icons.volume_up, size: h * 0.045,color: Palette.buttonColors,),
            ],
          ),


          // Source indicator
          Padding(
            padding:  EdgeInsets.only(top: h * 0.08),
            child: Center(
              child: GestureDetector(
                onTap: () async{
                  final Uri url = Uri.parse(controller.videoUrl.value.toString());
                  if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                  throw 'Could not launch $url';
                  }

                },
                child: Chip(
                  avatar: Icon(
                    controller.videoSource.value == VideoSource.youtube
                      ? Icons.smart_display
                      : Icons.video_library,
                    size: 18,
                  ),
                  label: Text(
                    controller.videoSource.value == VideoSource.youtube
                      ? 'YouTube'
                      : 'Vimeo'
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}