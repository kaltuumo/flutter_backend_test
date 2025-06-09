import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:flutter_app/src/features/core/repositories/post_repository.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;
  final isPostCreated = false.obs;

  final RxList<PostModel> posts = <PostModel>[].obs; // ✅ Add this

  final PostRepository _postRepository = PostRepository();

  Future<void> createPost() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Both title and description are required');
      return;
    }

    isLoading(true);

    final post = PostModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    bool success = await _postRepository.createPost(post);

    if (success) {
      titleController.clear();
      descriptionController.clear();
      Get.snackbar('Success', 'Post created successfully');
      isPostCreated(true);
      fetchAllPosts(); // 🔹 Optionally refresh posts after creation
    } else {
      Get.snackbar('Error', 'Failed to create post');
      isPostCreated(false);
    }

    isLoading(false);
  }

  void fetchAllPosts() async {
    try {
      isLoading.value = true;
      final data = await _postRepository.fetchPosts();
      posts.assignAll(data); // Save posts to the observable list
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
