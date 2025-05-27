// lib/src/features/auth/controllers/auth_controller.dart

import 'package:flutter_app/src/features/core/models/user_profile.dart';
import 'package:flutter_app/src/features/core/repositories/user_profile_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileController extends GetxController {
  final UserProfileRepository _userRepository;

  UserProfileController(this._userRepository);

  var isLoggedIn = false.obs;
  var user = User(id: '', fullname: '', email: '', phone: '').obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  // Load user from SharedPreferences
  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userEmail = prefs.getString('email');

    if (token != null && userEmail != null) {
      isLoggedIn(true);
      try {
        final users = await _userRepository.getAllUsers(token);
        final currentUser = users.firstWhere(
          (user) => user.email == userEmail,
          orElse: () => User(id: '', fullname: '', email: '', phone: ''),
        );
        user(currentUser);
      } catch (e) {
        isLoggedIn(false);
        print("Error loading user: $e");
      }
    } else {
      isLoggedIn(false);
    }
  }
}
