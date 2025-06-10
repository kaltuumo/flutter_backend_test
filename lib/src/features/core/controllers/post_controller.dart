import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:flutter_app/src/features/core/repositories/post_repository.dart';
import 'package:flutter_app/src/utilities/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;
  final isPostCreated = false.obs;
  String? selectedPostId;

  void setSelectedPostId(String id) {
    selectedPostId = id;
  }

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

  //Delete Post
  Future<void> deletePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected for deletion');
      return;
    }

    isLoading(true);

    bool success = await _postRepository.deletePost(
      selectedPostId!,
      posts.firstWhere((post) => post.id == selectedPostId),
    );

    if (success) {
      Get.snackbar('Success', 'Post deleted successfully');
      selectedPostId = null;
      fetchAllPosts();
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
