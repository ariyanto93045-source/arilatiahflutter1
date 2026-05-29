import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'preference_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),

        actions: [
          IconButton(
            onPressed: () async {
              // HAPUS LOGIN
              await PreferenceHandler.setLogin(false);

              // PINDAH KE LOGIN
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );

              // SNACKBAR
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Berhasil Logout")),
              ); // hanya untuk notifikasi saja
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: const Center(
        child: Text("Selamat Datang", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
