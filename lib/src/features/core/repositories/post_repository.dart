import 'package:flutter_app/src/services/api_client.dart';
import '../models/post_model.dart';

class PostRepository {
  Future<bool> createPost(PostModel post) {
    return ApiClient.createPost(post);
  }

  Future<List<PostModel>> fetchPosts() async {
    final postsData = await ApiClient.getPosts(); // API call
    return postsData
        .map<PostModel>((json) => PostModel.fromJson(json))
        .toList();
  }
}
