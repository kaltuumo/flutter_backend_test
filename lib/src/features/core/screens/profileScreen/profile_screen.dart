import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/auth/controllers/auth_controller.dart';
import 'package:flutter_app/src/features/core/screens/profileScreen/widget/profile_widget.dart';
import 'package:flutter_app/src/shared/widgets/custom_appbar.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/images.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/src/services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.find<AuthController>();
  String fullname = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Method to load user data from SharedPreferences and API
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userEmail = prefs.getString('email');

    if (token != null && userEmail != null) {
      try {
        final response = await ApiClient.getAllUsers(token);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final users = responseData['data'] as List;

          final currentUser = users.firstWhere(
            (user) => user['email'] == userEmail,
            orElse: () => null,
          );

          if (currentUser != null) {
            setState(() {
              fullname = currentUser['fullname'] ?? 'Unknown';
              email = currentUser['email'] ?? 'Unknown';
              phone = currentUser['phone'] ?? 'Unknown';
            });
          } else {
            _showError('User not found');
          }
        } else {
          _showError('Failed to load user data');
        }
      } catch (e) {
        _showError('Error: $e');
      }
    } else {
      _showError('Login data missing. Please login again.');
    }
  }

  // Helper method to show error messages
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: "Profile"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                // Profile image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.grey, width: 2),
                    image: DecorationImage(
                      image: AssetImage(AppImages.profileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // User info
                Text(fullname, style: TextStyle(fontSize: AppSizes.fontSizeLg)),
                Text(email, style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                SizedBox(height: 24),

                // Profile details
                ProfileWidget(
                  text: "Username",
                  subText: fullname,
                  iconData: Icons.person,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Phone",
                  subText: phone,
                  iconData: Icons.phone,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Status",
                  subText: "Active",
                  iconData: Icons.star_outline_sharp,
                ),

                // Logout button
                Container(
                  width: 130,
                  height: 50,
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await authController.logoutUser();
                          Get.offAllNamed('/login'); // Redirect to login page
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout,
                              size: AppSizes.iconMd,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: AppSizes.fontSizeMd,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
