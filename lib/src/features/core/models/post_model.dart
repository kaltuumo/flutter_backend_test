import 'dart:convert';
import 'dart:typed_data';

class PostModel {
  final String? id;
  final String title;
  final String description;
  final String? base64Image;

  PostModel({
    this.id,
    required this.title,
    required this.description,
    this.base64Image,
  });

  // Computed property to decode base64 string
  Uint8List? get imageBytes {
    if (base64Image == null) return null;
    try {
      final base64Str = base64Image!.split(',').last;
      return base64Decode(base64Str);
    } catch (e) {
      return null;
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      base64Image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (base64Image != null) 'image': base64Image,
    };
  }
}
