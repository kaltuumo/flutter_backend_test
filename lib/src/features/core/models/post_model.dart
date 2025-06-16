import 'dart:convert';
import 'dart:typed_data';

class PostModel {
  final String? id;
  final String title;
  final String description;
  final String? base64Image;
  final String? createdAt;
  final String? updatedAt;

  PostModel({
    this.id,
    required this.title,
    required this.description,
    this.base64Image,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      base64Image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image': base64Image};
  }

  Uint8List? get imageBytes =>
      base64Image != null ? base64Decode(base64Image!.split(',').last) : null;
}
