import 'dart:async';

import 'package:arilatiahflutter1/extension/navigator.dart';
import 'package:flutter/material.dart';

import 'package:arilatiahflutter1/login_screen.dart';
import 'package:arilatiahflutter1/preference_handler.dart';
import 'package:arilatiahflutter1/views/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (PreferenceHandler.isLogin) {
      context.pushAndRemoveAll(const MainNavigationScreen());
    } else {
      context.pushAndRemoveAll(const LoginScreen());
    }
  }

  // void initState() {
  //   super.initState();

  // // TIMER SPLASH SCREEN
  // Timer(const Duration(seconds: 2), () {

  //   // CEK STATUS LOGIN
  //   if (PreferenceHandler.isLogin) {
  //     // KE HOME
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //   } else {
  //     // KE LOGIN
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginScreen()),
  //     );
  //   }
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GAMBAR
            Image.asset('assetimage/image/logo ppkd 3.png', width: 150),

            const SizedBox(height: 20),

            // JUDUL
            const Text(
              "MY APP",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // LOADING untu membuat loading sambil menunggu waktu 3 detih untuk masuk ke homescreen
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
