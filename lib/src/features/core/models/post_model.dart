class PostModel {
  final String? id; // Make sure this exists
  final String title;
  final String description;

  PostModel({this.id, required this.title, required this.description});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }
}
