import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    // Call fetchAllPosts when HomeScreen is loaded
    postController.fetchAllPosts();

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Post'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fill in the post details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: postController.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: postController.descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () =>
                  postController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          ElevatedButton(
                            onPressed: postController.createPost,
                            child: const Text("Create Post"),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),

                          const Text(
                            "All Posts",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: postController.posts.length,
                              itemBuilder: (context, index) {
                                final post = postController.posts[index];
                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text(post.description),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
