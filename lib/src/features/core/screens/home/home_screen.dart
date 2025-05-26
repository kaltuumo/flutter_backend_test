import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/auth/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Tirtir token-ka ku jira SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // ama await prefs.remove('token');
            print("🧹 Token-ka waa la tirtiray");

            // Ku celi LoginScreen
            Get.offAll(() => LoginScreen());
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
