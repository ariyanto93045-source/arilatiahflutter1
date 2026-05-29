import 'package:arilatiahflutter1/homescreen.dart';
import 'package:flutter/material.dart';

import 'preference_handler.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // SIMPAN LOGIN
            await PreferenceHandler.setLogin(true);

            // PINDAH KE HOME
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },

          child: const Text("Masuk"),
        ),
      ),
    );
  }
}
