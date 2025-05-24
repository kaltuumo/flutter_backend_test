import 'package:flutter/material.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,

    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.hintText = '',
    r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
        border: Border.all(color: AppColors.primary, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            width: 250,
            height: 50,
            decoration: BoxDecoration(color: AppColors.white),
            child: TextFormField(
              decoration: InputDecoration(
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.md,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
