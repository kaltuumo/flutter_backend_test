import 'package:flutter/material.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:flutter_app/src/utilities/constants/sizes.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppbar({Key? key, required this.title, this.onBack})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppSizes.fontSizeXl,
          // fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: onBack ?? () => Get.back(),
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          color: AppColors.grey.withOpacity(0.5),
          thickness: 1,
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
