import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/core/screens/home/home_screen.dart';
import 'package:flutter_app/src/features/core/screens/profileScreen/profile_screen.dart';
import 'package:flutter_app/src/utilities/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key, this.initialIndex = 0});

  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: AppColors.white,
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),

            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        );
      }),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class _NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomeScreen(), ProfileScreen()];
}
