import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/auth/controllers/auth_controller.dart';
import 'package:flutter_app/src/features/core/screens/profileScreen/widget/profile_widget.dart';
import 'package:flutter_app/src/shared/widgets/custom_appbar.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/images.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: "Profile"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
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
                Text(
                  "Khaliil Company",
                  style: TextStyle(fontSize: AppSizes.fontSizeLg),
                ),
                Text("Admin", style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Username",
                  subText: "Dev",
                  iconData: Icons.person,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Phone",
                  subText: "0618908976",
                  iconData: Icons.phone,
                ),
                SizedBox(height: 24),
                ProfileWidget(
                  text: "Status",
                  subText: "Active",
                  iconData: Icons.star_outline_sharp,
                ),
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
                          await authController
                              .logoutUser(); // Call loginUser method
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
                              "logout",
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
