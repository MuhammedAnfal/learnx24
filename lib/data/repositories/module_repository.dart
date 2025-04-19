import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../features/learning/home/models/video_model.dart';
import '../../features/learning/module/models/module_model.dart';

class ModuleRepository extends GetxController {
  static ModuleRepository get instance => Get.find();

  Future<List<ModuleModel>> getModules({required int subjectId}) async {
    final response = await http.get(Uri.parse('https://trogon.info/interview/php/api/modules.php?subject_id=$subjectId'));
    if (response.statusCode == 200) {
      print('if workedd');
      final List<dynamic> jsonData = jsonDecode(response.body);
      print('1111');
      print(subjectId);
      print('1111');

      return jsonData.map((subject) => ModuleModel.fromJson(subject)).toList();
    } else {
      throw Exception('Failed to load subjects. Status code: ${response.statusCode}');
    }
  }
  
  Future<List<VideoModel>> getVideos({required int subjectId}) async {
    final response = await http.get(Uri.parse('https://trogon.info/interview/php/api/videos.php?module_id=$subjectId'));
    if (response.statusCode == 200) {
      print('if workedd');
      final List<dynamic> jsonData = jsonDecode(response.body);
      print('1111');
      print(subjectId);
      print('1111');

      return jsonData.map((subject) => VideoModel.fromJson(subject)).toList();
    } else {
      throw Exception('Failed to load subjects. Status code: ${response.statusCode}');
    }
  }
}
