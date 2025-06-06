import 'dart:convert';
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

      print('Response: ${response.statusCode}');
      print('Body: ${response.body}');

      // ✅ Allow both 200 and 201 status codes as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        String token =
            responseBody['result']['_id']; // Change 'token' to '_id' based on your response

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email); // Saving the email as well

        Get.snackbar('Success', 'Account created successfully');
        return true; // Return true to indicate success
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Signup failed';
        Get.snackbar('Error', errorMessage);
        return false; // Return false for failure
      }
    } catch (e) {
      print('Signup Error: $e');
      Get.snackbar('Error', 'Something went wrong during signup');
      return false; // Return false for error
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

        // Optional: save token
        String token = responseBody['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Get.snackbar('Success', 'Logged in successfully');

        // ✅ Return user object (assumes you get user in response)
        return responseBody['user']; // <-- adjust this if your response is different
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'User does not exist';
        Get.snackbar('Error', errorMessage);
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      print('Login Error: $e');
      return null;
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

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => LoginScreen());
  }
}
