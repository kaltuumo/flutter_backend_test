import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_app/src/features/core/controllers/post_controller.dart';

class HomeScreen extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create or Update Post'),
        centerTitle: true,
      ),
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

            // Title Input Field
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

            // Description Input Field
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
            const SizedBox(height: 16),

            // Upload Image Button
            ElevatedButton.icon(
              onPressed: postController.pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Upload Image'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            // Show selected image
            Obx(() {
              if (postController.selectedImage.value != null) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.file(
                      postController.selectedImage.value!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selected Image: ${postController.selectedImage.value!.path}',
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 30),

            // Create or Update Post Buttons
            Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: postController.createPost,
                    icon: const Icon(Icons.add),
                    label: const Text("Create Post"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: postController.updatePost,
                    icon: const Icon(Icons.update),
                    label: const Text("Update Post"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "All Posts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // List of Posts
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: postController.posts.length,
                itemBuilder: (context, index) {
                  final post = postController.posts[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading:
                          post.imageBytes != null
                              ? CircleAvatar(
                                backgroundImage: MemoryImage(post.imageBytes!),
                                radius: 25,
                              )
                              : const CircleAvatar(
                                child: Icon(Icons.image, color: Colors.white),
                                backgroundColor: Colors.grey,
                                radius: 25,
                              ),
                      title: Text(post.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.description),
                          if (post.createdAt != null)
                            Text('Created At: ${post.createdAt}'),
                          if (post.updatedAt != null)
                            Text('Updated At: ${post.updatedAt}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              postController.titleController.text = post.title;
                              postController.descriptionController.text =
                                  post.description;
                              postController.setSelectedPostId(post.id!);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              postController.setSelectedPostId(post.id!);
                              await postController.deletePost();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
