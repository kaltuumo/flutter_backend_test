import 'dart:typed_data';

class PostImageHelper {
  // Function to extract image data (convert buffer to Uint8List)
  static Uint8List? fromJson(Map<String, dynamic> json) {
    try {
      if (json['image'] != null &&
          json['image']['data'] != null &&
          json['image']['data']['data'] != null) {
        List<dynamic> dataList = json['image']['data']['data'];
        return Uint8List.fromList(dataList.cast<int>());
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // Optionally, you can add a function to convert back to json
  static Map<String, dynamic> toJson(Uint8List? image) {
    if (image != null) {
      return {
        'data': {'type': 'Buffer', 'data': image.toList()},
      };
    }
    return {};
  }
}
