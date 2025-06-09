import 'package:flutter/material.dart';
import 'package:flutter_app/app_navigator.dart';
import 'package:flutter_app/src/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/features/auth/screens/login_screen.dart';

void main() async {
  // Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController()); // Register your AuthController here
  // Get.put(PostController()); // Register your PostController here

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print("🎯 Token at startup: $token"); // ✅ Moved inside build method

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null ? AppNavigator() : LoginScreen(),
    );
  }
}
