import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/controllers/post_controller.dart';
import 'package:get/get.dart';

class ReadPostsPage extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
        centerTitle: true,
        elevation: 2,
      ),
      // body: Obx(
      //   () {
      //     if (postController.isLoading.value) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     if (postController.posts.isEmpty) {
      //       return const Center(child: Text('No posts available.'));
      //     }

      //     return ListView.builder(
      //       padding: const EdgeInsets.all(16),
      //       // itemCount: postController.posts.length,
      //       itemBuilder: (context, index) {
      //         // final post = postController.posts[index];

      //         return Card(
      //           elevation: 4,
      //           margin: const EdgeInsets.symmetric(vertical: 8),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: ListTile(
      //             contentPadding: const EdgeInsets.all(16),
      //             title: Text(
      //               post['title'],
      //               style: const TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             subtitle: Text(
      //               post['description'],
      //               style: const TextStyle(fontSize: 14),
      //             ),
      //             trailing: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 IconButton(
      //                   icon: const Icon(Icons.edit),
      //                   color: Colors.blue,
      //                   onPressed: () {
      //                     // Handle update action
      //                   },
      //                 ),
      //                 IconButton(
      //                   icon: const Icon(Icons.delete),
      //                   color: Colors.red,
      //                   onPressed: () {
      //                     // Handle delete action
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
