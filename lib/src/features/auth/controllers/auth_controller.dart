import 'package:flutter/material.dart';
import 'package:flutter_app/src/services/api_client.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
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
    await ApiClient.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    isLoading(false);
  }

  Future<void> logoutUser() async {
    await ApiClient.logout();
  }
}
