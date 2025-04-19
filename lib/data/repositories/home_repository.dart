import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../features/learning/home/models/subject_model.dart';

class HomeRepository extends GetxController {
  static HomeRepository get instance => Get.find();

  Future<List<SubjectModel>> getSubjects() async {
    final response = await http.get(Uri.parse('https://trogon.info/interview/php/api/subjects.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((subject) => SubjectModel.fromJson(subject)).toList();
    } else {
      throw Exception('Failed to load subjects. Status code: ${response.statusCode}');
    }
  }

  
}
