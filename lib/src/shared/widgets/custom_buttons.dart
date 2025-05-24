import 'package:flutter/material.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';

class CustomButtons extends StatelessWidget {
  final String text;

  final Function()? onTap;
  const CustomButtons({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppSizes.fontSizeLg,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}
