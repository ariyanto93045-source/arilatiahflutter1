import 'package:flutter/material.dart';

class tugas8 extends StatelessWidget {
  const tugas8({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: const [
            Text(
              "Tentang Aplikasi",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              "Aplikasi ini dibuat menggunakan Flutter "
              "untuk tugas navigasi multi-level "
              "dengan BottomNavigationBar.",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),

            Text("Nama Pembuat: Ariyanto", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text("Versi Aplikasi: 1.0.0", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
