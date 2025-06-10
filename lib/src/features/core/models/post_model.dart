import 'dart:typed_data';

class PostModel {
  final String? id;
  final String title;
  final String description;
  final Uint8List? image;

  PostModel({
    this.id,
    required this.title,
    required this.description,
    this.image,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    Uint8List? imageData;
    try {
      if (json['image'] != null &&
          json['image']['data'] != null &&
          json['image']['data']['data'] != null) {
        List<dynamic> dataList = json['image']['data']['data'];
        imageData = Uint8List.fromList(dataList.cast<int>());
      }
    } catch (_) {
      imageData = null;
    }

    return PostModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      image: imageData,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }
}
