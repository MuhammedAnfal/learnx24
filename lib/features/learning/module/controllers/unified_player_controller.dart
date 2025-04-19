import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum VideoSource { youtube, vimeo, none, webview }

class UnifiedPlayerController extends GetxController {
  //variables
  var videoSource = VideoSource.none.obs;
  var videoId = ''.obs;
  var isPlaying = false.obs;
  var currentPosition = 0.0.obs;
  var duration = 0.0.obs;
  var volume = 100.0.obs;
  var isMuted = false.obs;
  var isLoading = false.obs;
  var isInitialized = false.obs;
  var errorMessage = ''.obs;
  var videoTitle = 'No video loaded'.obs;
  RxString videoUrl = ''.obs;
  YoutubePlayerController? youtubeController;
  VideoPlayerController? vimeoVideoController;
  ChewieController? chewieController;
  InAppWebViewController? webViewController;

  @override
  void onReady() {
    super.onReady();
    loadVideoFromUrl(videoUrl.value);
  }

  void loadVideoFromUrl(String videoUrl) async {
    if (videoUrl.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      disposeCurrentControllers();
      isInitialized.value = false;
      currentPosition.value = 0.0;
      duration.value = 0.0;

      if (isYouTubeUrl(videoUrl)) {
        String? id = extractYouTubeVideoId(videoUrl);
        if (id != null) {
          videoSource.value = VideoSource.youtube;
          videoId.value = id;
          await initializeYouTubePlayer(id);
        } else {
          errorMessage.value = 'Invalid YouTube URL';
        }
      } else if (isVimeoUrl(videoUrl)) {
        String? id = extractVimeoVideoId(videoUrl);
        if (id != null) {
          videoSource.value = VideoSource.vimeo;
          videoId.value = id;
          bool success = await initializeVimeoPlayer(id);
          if (!success) {
            videoSource.value = VideoSource.webview;
            isInitialized.value = true;
            videoTitle.value = 'Vimeo Video $id';
          }
        } else {
          errorMessage.value = 'Invalid Vimeo URL';
        }
      } else {
        errorMessage.value = 'Unsupported video URL';
      }
    } catch (e) {
      errorMessage.value = 'Error loading video: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // YouTube Player Methods
  bool isYouTubeUrl(String videoUrl) {
    return videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be');
  }

  String? extractYouTubeVideoId(String videoUrl) {
    try {
      return YoutubePlayer.convertUrlToId(videoUrl);
    } catch (e) {
      print('Error extracting YouTube ID: $e');
      return null;
    }
  }

  Future<void> initializeYouTubePlayer(String videoId) async {
    try {
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: true,
        ),
      );

      youtubeController!.addListener(() {
        if (youtubeController!.value.isReady && !isInitialized.value) {
          isInitialized.value = true;
          videoTitle.value = youtubeController!.metadata.title;
        }

        isPlaying.value = youtubeController!.value.isPlaying;
        currentPosition.value = youtubeController!.value.position.inSeconds.toDouble();
        duration.value = youtubeController!.metadata.duration.inSeconds.toDouble();
      });
    } catch (e) {
      errorMessage.value = 'Error initializing YouTube player: ${e.toString()}';
      print('Error in initializeYouTubePlayer: $e');
    }
  }

  // Vimeo Player
  bool isVimeoUrl(String videoUrl) {
    return videoUrl.contains('vimeo');
  }

  String? extractVimeoVideoId(String videoUrl) {
    try {
      RegExp regExp = RegExp(r'vimeo\.com/(\d+)');
      Match? match = regExp.firstMatch(videoUrl);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }

      regExp = RegExp(r'player\.vimeo\.com/video/(\d+)');
      match = regExp.firstMatch(videoUrl);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }

      return null;
    } catch (e) {
      print('Error extracting Vimeo ID: $e');
      return null;
    }
  }

  Future<bool> initializeVimeoPlayer(String videoId) async {
    try {
      final response = await http.get(
        Uri.parse('https://vimeo.com/api/v2/video/$videoId.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          videoTitle.value = data[0]['title'] ?? 'Vimeo Video $videoId';
          String? videoUrl = data[0]['url'];
          if (videoUrl != null && videoUrl.isNotEmpty) {
            vimeoVideoController = VideoPlayerController.network(videoUrl);
            await vimeoVideoController!.initialize();

            chewieController = ChewieController(
              videoPlayerController: vimeoVideoController!,
              autoPlay: true,
              looping: false,
              aspectRatio: vimeoVideoController!.value.aspectRatio,
            );

            vimeoVideoController!.addListener(updateVimeoPlayerState);
            return true;
          }
        }
      }

      String? fallbackUrl = await getVimeoFallbackUrl(videoId);
      if (fallbackUrl != null) {
        vimeoVideoController = VideoPlayerController.network(fallbackUrl);
        await vimeoVideoController!.initialize();

        chewieController = ChewieController(
          videoPlayerController: vimeoVideoController!,
          autoPlay: true,
          looping: false,
          aspectRatio: vimeoVideoController!.value.aspectRatio,
        );

        vimeoVideoController!.addListener(updateVimeoPlayerState);
        return true;
      }

      return false;
    } catch (e) {
      print('Error initializing Vimeo player: $e');
      return false;
    }
  }

  void updateVimeoPlayerState() {
    isPlaying.value = vimeoVideoController!.value.isPlaying;
    currentPosition.value = vimeoVideoController!.value.position.inSeconds.toDouble();
    duration.value = vimeoVideoController!.value.duration.inSeconds.toDouble();

    if (!isInitialized.value && vimeoVideoController!.value.isInitialized) {
      isInitialized.value = true;
    }
  }

  Future<String?> getVimeoFallbackUrl(String videoId) async {
    try {
      final response = await http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config'),
        headers: {'Referer': 'https://vimeo.com/'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final files = data['request']['files'];

        if (files['progressive'] != null && files['progressive'] is List) {
          final progressive = files['progressive'] as List;
          if (progressive.isNotEmpty) {
            progressive.sort((a, b) => (b['width'] as int).compareTo(a['width'] as int));
            return progressive.first['url'];
          }
        }
      }

      return 'https://player.vimeo.com/progressive_redirect/playback/$videoId/rendition/720p?loc=external';
    } catch (e) {
      return null;
    }
  }

  void disposeCurrentControllers() {
    if (youtubeController != null) {
      youtubeController!.dispose();
      youtubeController = null;
    }

    if (chewieController != null) {
      chewieController!.dispose();
      chewieController = null;
    }

    if (vimeoVideoController != null) {
      vimeoVideoController!.dispose();
      vimeoVideoController = null;
    }

    if (webViewController != null) {
      webViewController = null;
    }
  }

  // Player control
  void playPause() {
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      if (youtubeController!.value.isPlaying) {
        youtubeController!.pause();
      } else {
        youtubeController!.play();
      }
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      if (vimeoVideoController!.value.isPlaying) {
        vimeoVideoController!.pause();
      } else {
        vimeoVideoController!.play();
      }
    }
  }

  void forward10Seconds() {
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      youtubeController!.seekTo(Duration(seconds: youtubeController!.value.position.inSeconds + 10));
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      vimeoVideoController!.seekTo(Duration(seconds: vimeoVideoController!.value.position.inSeconds + 10));
    }
  }

  void rewind10Seconds() {
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      youtubeController!.seekTo(Duration(seconds: youtubeController!.value.position.inSeconds - 10));
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      vimeoVideoController!.seekTo(Duration(seconds: vimeoVideoController!.value.position.inSeconds - 10));
    }
  }

  void setVolume(double value) {
    volume.value = value;
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      youtubeController!.setVolume(value.toInt());
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      vimeoVideoController!.setVolume(value / 100);
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      if (isMuted.value) {
        youtubeController!.mute();
      } else {
        youtubeController!.unMute();
        youtubeController!.setVolume(volume.value.toInt());
      }
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      vimeoVideoController!.setVolume(isMuted.value ? 0 : volume.value / 100);
    }
  }

  void seekTo(double position) {
    if (videoSource.value == VideoSource.youtube && youtubeController != null) {
      youtubeController!.seekTo(Duration(seconds: position.toInt()));
    } else if (videoSource.value == VideoSource.vimeo && vimeoVideoController != null) {
      vimeoVideoController!.seekTo(Duration(seconds: position.toInt()));
    }
  }

  @override
  void onClose() {
    disposeCurrentControllers();
    super.onClose();
  }
}