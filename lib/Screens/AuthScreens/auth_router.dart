
import 'package:dwa2y_pharmacy/Controllers/auth_controller.dart';
import 'package:dwa2y_pharmacy/Screens/AuthScreens/login_screen.dart';
import 'package:dwa2y_pharmacy/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthRouter extends GetView<AuthController>{
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.currentUser.value!=null?const Dashboard(): LoginScreen(),
    );
  }
}