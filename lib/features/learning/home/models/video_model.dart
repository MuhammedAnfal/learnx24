class VideoModel {
  int? id;
  String? title;
  String? description;
  String? videoType;
  String? videoUrl;

  VideoModel(
      {this.id, this.title, this.description, this.videoType, this.videoUrl});

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['video_type'] = videoType;
    data['video_url'] = videoUrl;
    return data;
  }
}
