import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:flutter_app/src/features/core/repositories/post_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final isLoading = false.obs;
  final isPostCreated = false.obs;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  String? selectedPostId;
  final ImagePicker _picker = ImagePicker();
  String? base64Image;
  final PostRepository _postRepository = PostRepository();

  @override
  void onInit() {
    fetchAllPosts(); // Call once
    super.onInit();
  }

  void setSelectedPostId(String id) {
    selectedPostId = id;
  }

  void setSelectedImage(File image) {
    selectedImage.value = image;
  }

  Future<void> pickImage() async {
    print("Picking image...");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image Selected: ${image.path}");
      selectedImage.value = File(image.path); // Convert XFile to File
    } else {
      print("No Image Selected");
      print("Base64 Image: $base64Image");
    }
  }

  Future<void> createPost() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Title and Description required');
      return;
    }

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
        base64Image: base64Image, // Ensure image data is passed correctly
      );

      bool success = await _postRepository.createPost(post);

      if (success) {
        titleController.clear();
        descriptionController.clear();
        selectedImage.value = null;
        Get.snackbar('Success', 'Post created');
        isPostCreated(true);
        await fetchAllPosts();
      } else {
        Get.snackbar('Error', 'Post creation failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected');
      return;
    }

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Title and Description required');
      return;
    }

    try {
      isLoading(true);

      String? base64Image;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
      }

      final post = PostModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        base64Image: base64Image,
      );

      bool success = await _postRepository.updatePost(selectedPostId!, post);

      if (success) {
        Get.snackbar('Updated', 'Post updated');
        selectedPostId = null;
        titleController.clear();
        descriptionController.clear();
        selectedImage.value = null;
        await fetchAllPosts();
      } else {
        Get.snackbar('Error', 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePost() async {
    if (selectedPostId == null) {
      Get.snackbar('Error', 'No post selected');
      return;
    }

    try {
      isLoading(true);
      bool success = await _postRepository.deletePost(selectedPostId!);

      if (success) {
        Get.snackbar('Deleted', 'Post deleted');
        selectedPostId = null;
        await fetchAllPosts();
      } else {
        Get.snackbar('Error', 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      isLoading(true);
      final data = await _postRepository.fetchPosts();
      posts.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", 'Fetch failed: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
