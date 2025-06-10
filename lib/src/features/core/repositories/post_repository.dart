import 'package:flutter_app/src/services/api_client.dart';
import '../models/post_model.dart';

class PostRepository {
  // Create a post
  Future<bool> createPost(PostModel post) {
    return ApiClient.createPost(post);
  }

  // Fetch all posts
  Future<List<PostModel>> fetchPosts() async {
    final postsData = await ApiClient.getPosts(); // API call
    return postsData
        .map<PostModel>((json) => PostModel.fromJson(json))
        .toList();
  }

  // Update a post
  Future<bool> updatePost(String id, PostModel post) {
    return ApiClient.updatePost(id, post);
  }

  // Delete a post by id
  Future<bool> deletePost(String id) {
    return ApiClient.deletePost(id); // Only pass the id for deletion
  }
}
