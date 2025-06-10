import 'dart:convert';
import 'package:flutter_app/src/features/core/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/src/utilities/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter_app/src/features/auth/screens/login_screen.dart';

class ApiClient {
  static Future<bool> signup({
    required String fullname,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.authEndpoint}/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        String token = responseBody['token']; // ✅ Correct field

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Get.snackbar('Success', 'Account created successfully');
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Signup failed';
        Get.snackbar('Error', errorMessage);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong during signup');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstants.authEndpoint}/signin');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Token ka soo qaad response-ka
        String token = responseBody['token'];

        // Kaydi token-ka si uu noqdo mid default ah
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Get.snackbar('Success', 'Logged in successfully');
        return responseBody['user'];
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'User does not exist';
        Get.snackbar('Error', errorMessage);
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return null;
    }
  }

  static Future<bool> createPost(PostModel post) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    final url = Uri.parse('${ApiConstants.postEndpoint}/create-post');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['message'] ?? 'Failed to create post';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  static Future<List<dynamic>> getPosts() async {
    final url = Uri.parse(
      '${ApiConstants.postEndpoint}/all-posts',
    ); // URL sax ah

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body); // Parse JSON response

        List posts = jsonBody['data']; // Kaliya xogta 'data' ka soo qaad
        // print("RESPONSE DATA: $jsonBody"); // ✅ Aragtid xogta

        // Loop through each post and handle the image if exists
        for (var post in posts) {
          if (post['image'] != null) {
            // If there's an image, we convert the base64 string to an image
            post['image'] =
                post['image']; // Here you can handle the image as needed
          }
        }

        return posts; // Return list of posts with image data
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  static Future<http.Response> getAllUsers(String token) async {
    final url = Uri.parse('${ApiConstants.profileEndpoint}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  /// Update Post

  static Future<bool> updatePost(String id, PostModel post) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    final url = Uri.parse('${ApiConstants.postEndpoint}/update-post?_id=$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['message'] ?? 'Failed to update post';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
      return false;
    }
  }

  static Future<bool> deletePost(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Sending token: $token');

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'No token found');
      return false;
    }

    final url = Uri.parse(
      '${ApiConstants.postEndpoint}/delete-post?_id=$id',
    ); // Correct URL with query string

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Ensure token is being sent in the header
        },
      );

      if (response.statusCode == 200) {
        print('Post deleted successfully');
        return true;
      } else {
        print('Failed to delete post: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Tirtir dhammaan xogta keydka
    Get.offAll(() => LoginScreen());
  }
}
