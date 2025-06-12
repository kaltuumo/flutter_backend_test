import 'dart:convert';
import 'dart:io'; // for File
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:flutter_app/src/features/core/repositories/post_repository.dart';
import 'package:flutter_app/src/services/api_client.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final currentDate = ApiClient.formatDate(DateTime.now().toIso8601String());

  final isLoading = false.obs;
  final isPostCreated = false.obs;
  String? selectedPostId;

  // Observable list of posts
  final RxList<PostModel> posts = <PostModel>[].obs;
  final Rx<File?> selectedImage = Rx<File?>(null); // Store selected image

  final PostRepository _postRepository = PostRepository();
  final ImagePicker _picker = ImagePicker();

  // Set selected post ID
  void setSelectedPostId(String id) {
    selectedPostId = id;
  }

  // Set selected image
  void setSelectedImage(File image) {
    selectedImage.value = image;
  }

  // Create a new post

  Future<void> createPost() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Both title and description are required');
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading(true);

      String? base64Image;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        final mimeType =
            selectedImage.value!.path.endsWith('.jpg') ||
                    selectedImage.value!.path.endsWith('.jpeg')
                ? 'image/jpeg'
                : 'image/png';
        base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
      }

      final post = PostModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        base64Image: base64Image,
      );

      bool success = await _postRepository.createPost(post);

      if (success) {
        titleController.clear();
        descriptionController.clear();
        selectedImage.value = null;
        Get.snackbar('Success', 'Post created successfully');
        isPostCreated(true);
        await fetchAllPosts(); // Refresh list
      } else {
        Get.snackbar('Error', 'Failed to create post');
        isPostCreated(false);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      isLoading(true);
      final data = await _postRepository.fetchPosts();
      posts.assignAll(data); // Save posts to the observable list
    } catch (e) {
      Get.snackbar("Error", 'Failed to fetch posts: $e');
    } finally {
      isLoading(false);
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

    try {
      isLoading(true);

      final post = PostModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        base64Image:
            selectedImage.value != null
                ? 'data:image/png;base64,${base64Encode(await selectedImage.value!.readAsBytes())}'
                : null,
      );

      bool success = await _postRepository.updatePost(selectedPostId!, post);

      if (success) {
        Get.snackbar('Success', 'Post updated successfully');
        selectedPostId = null;
        titleController.clear();
        descriptionController.clear();
        selectedImage.value = null; // Clear image after successful update
        await fetchAllPosts();
      } else {
        Get.snackbar('Error', 'Failed to update post');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating the post: $e');
    } finally {
      isLoading(false);
    }
  }

  // Delete a selected post
  Future<void> deletePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected for deletion');
      return;
    }

    try {
      isLoading(true);

      // Pass only the selectedPostId for deletion
      bool success = await _postRepository.deletePost(selectedPostId!);

      if (success) {
        Get.snackbar('Success', 'Post deleted successfully');
        selectedPostId = null;
        await fetchAllPosts(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete post');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the post: $e');
    } finally {
      isLoading(false);
    }
  }

  // Pick an image from the gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setSelectedImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while picking an image: $e');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
