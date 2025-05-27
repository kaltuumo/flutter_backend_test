// lib/src/features/core/repositories/user_profile_repository.dart

import 'dart:convert';
import 'package:flutter_app/src/features/core/models/user_profile.dart';
import 'package:flutter_app/src/services/api_client.dart';

class UserProfileRepository {
  final ApiClient apiClient;

  UserProfileRepository({required this.apiClient});

  // Login function
  Future<User?> login(String email, String password) async {
    final response = await ApiClient.login(email: email, password: password);
    if (response != null) {
      return User.fromJson(response); // Assuming your response is a user object
    }
    return null;
  }

  // Fetch all users
  Future<List<User>> getAllUsers(String token) async {
    final response = await ApiClient.getAllUsers(token);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      List<dynamic> usersJson = responseBody['data'];
      return usersJson.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
