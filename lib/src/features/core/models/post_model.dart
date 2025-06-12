import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

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

  // Computed property to decode base64 string
  Uint8List? get imageBytes {
    if (base64Image == null) return null;
    try {
      final clean =
          base64Image!.contains(',')
              ? base64Image!.split(',').last
              : base64Image!;
      return base64Decode(clean);
    } catch (e) {
      print('Image decode error: $e');
      return null;
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      base64Image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (base64Image != null) 'image': base64Image,
    };
  }

  // 🔽 Halkan ku dar getters-ka cusub
  String? get formattedCreatedAt {
    if (createdAt == null) return null;
    final date = DateTime.parse(createdAt!);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String? get formattedUpdatedAt {
    if (updatedAt == null) return null;
    final date = DateTime.parse(updatedAt!);
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
