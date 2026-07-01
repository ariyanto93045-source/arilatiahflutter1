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
    await Future.delayed(const Duration(seconds: 5));
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GAMBAR
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assetimage/image/logo moms kos (2).png', 
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              // JUDUL
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Selamat datang di absen kami",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // LOADING
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
