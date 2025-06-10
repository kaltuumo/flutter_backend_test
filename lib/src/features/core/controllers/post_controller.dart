import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:flutter_app/src/features/core/repositories/post_repository.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;
  final isPostCreated = false.obs;
  String? selectedPostId;

  // Set selected post ID
  void setSelectedPostId(String id) {
    selectedPostId = id;
  }

  // Observable list of posts
  final RxList<PostModel> posts = <PostModel>[].obs;

  final PostRepository _postRepository = PostRepository();

  // Create a new post
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
      fetchAllPosts(); // Optionally refresh posts after creation
    } else {
      Get.snackbar('Error', 'Failed to create post');
      isPostCreated(false);
    }

    isLoading(false);
  }

  // Fetch all posts
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

  // Update a selected post
  Future<void> updatePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected for update');
      return;
    }

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Both title and description are required');
      return;
    }

    isLoading(true);

    final post = PostModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    bool success = await _postRepository.updatePost(selectedPostId!, post);

    if (success) {
      Get.snackbar('Success', 'Post updated successfully');
      selectedPostId = null;
      titleController.clear();
      descriptionController.clear();
      fetchAllPosts();
    } else {
      Get.snackbar('Error', 'Failed to update post');
    }

    isLoading(false);
  }

  // Delete a selected post
  Future<void> deletePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected for deletion');
      return;
    }

    isLoading(true);

    // Pass only the selectedPostId for deletion
    bool success = await _postRepository.deletePost(selectedPostId!);

    if (success) {
      Get.snackbar('Success', 'Post deleted successfully');
      selectedPostId = null;
      fetchAllPosts(); // Refresh the list after deletion
    } else {
      Get.snackbar('Error', 'Failed to delete post');
    }

    isLoading(false);
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
