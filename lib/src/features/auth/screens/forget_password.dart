import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/auth/screens/login_screen.dart';
import 'package:flutter_app/src/shared/widgets/custom_buttons.dart';
import 'package:flutter_app/src/shared/widgets/custom_textfiled.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/images.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset(AppImages.appLogoFull, width: 250, height: 250),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xl,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Welcome to MaalPay',
                  style: TextStyle(
                    fontSize: AppSizes.fontSizeXl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please log in to continue',
                  style: TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Username",
                  prefixIcon: const Icon(Icons.person),
                ),

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButtons(text: "Send Code", onTap: () {}),
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeMd,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
