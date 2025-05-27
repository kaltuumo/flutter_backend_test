import 'package:flutter/material.dart';
import 'package:flutter_app/app_navigator.dart';
import 'package:flutter_app/src/services/api_client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final currentUserId = ''.obs; // Si aad ugu kaydiso user ID login kadib

  @override
  void onInit() {
    super.onInit();
    _loadStoredUserId(); // markuu app-ku furmo
  }

  void _loadStoredUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      currentUserId.value = userId;
    }
  }

  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void clearSignupFields() {
    fullnameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  Future<bool> signupUser() async {
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return false;
    }

    isLoading(true);
    bool result = await ApiClient.signup(
      fullname: fullnameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
    );
    isLoading(false);

    return result;
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading(true);

    try {
      final userData = await ApiClient.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userData != null && userData['id'] != null) {
        // Save the user ID to SharedPreferences after successful login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userData['id']);
        print('User ID saved to SharedPreferences: ${userData['id']}');

        // Set the user ID in the controller
        currentUserId.value = userData['id'];

        // Optionally, you can navigate to another page after successful login
        Get.offAll(() => AppNavigator());
      } else {
        Get.snackbar('Error', 'Invalid login response');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
      print("Login error: $e");
    } finally {
      isLoading(false);
    }
  }

  void loadStoredUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      currentUserId.value = userId;
      print('User ID loaded from SharedPreferences: $userId');
    } else {
      print('❌ No user ID found in SharedPreferences.');
    }
  }

  Future<void> logoutUser() async {
    await ApiClient.logout();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    currentUserId.value = '';
  }
}
