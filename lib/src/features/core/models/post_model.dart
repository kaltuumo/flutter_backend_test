class PostModel {
  final String title;
  final String description;

  PostModel({required this.title, required this.description});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'], // Title ka soo qaado response
      description: json['description'], // Description ka soo qaado response
    );
  }
}
