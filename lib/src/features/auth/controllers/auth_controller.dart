import 'package:flutter_app/src/features/core/home_screen.dart';
import 'package:flutter_app/src/utilities/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/auth/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Declare TextEditingControllers
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable for loading state
  var isLoading = false.obs;

  // Signup function
  Future<void> signupUser() async {
    // Check if any of the fields are empty
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading(true); // Set loading state to true

    final url = Uri.parse('${ApiConstants.baseUrl}/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullnameController.text.trim(),
          "email": emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      isLoading(false); // Set loading state to false

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Registration successful
        final responseBody = jsonDecode(response.body);
        String token = responseBody['token']; // Assuming token is returned

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.snackbar('Success', 'Account created successfully');
        await Future.delayed(Duration(seconds: 1)); // Delay before navigation
        Get.offAll(
          () => HomeScreen(),
        ); // Clear all previous screens and go to Home
      } else {
        // Registration failed
        final responseBody = jsonDecode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Failed to create account';
        Get.snackbar('Error', errorMessage);
      }
    } catch (error) {
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong, please try again later');
      print('Error: $error');
    }
  }

  // Login function

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading(true);

    final url = Uri.parse('${ApiConstants.baseUrl}/signin');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading(false);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String token = responseBody['token'];

        // ✅ Kaydi token iyo email
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);

        Get.snackbar('Success', 'Logged in successfully');
        Get.offAll(() => HomeScreen());
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'User does not exist';
        Get.snackbar('Error', errorMessage);
      }
    } catch (error) {
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong, please try again later');
      print('Error: $error');
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // ama prefs.remove('token') haddii aad rabto kaliya in aad token tirtirto
    Get.offAll(() => LoginScreen()); // Ku celi login screen
  }
}
