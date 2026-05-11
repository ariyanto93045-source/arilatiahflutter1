import 'package:flutter/material.dart';

class tugas extends StatelessWidget {
  const tugas ({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOKO LISTRIK"),
        backgroundColor: const Color.fromARGB(255, 64, 255, 80),
        centerTitle: true,
      ),
 // IDENTITAS UTAMA
          body: Column(
            children: [
              SizedBox(height: 10),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 240, 246),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.email, color: Color.fromARGB(255, 183, 58, 146)),

                  SizedBox(width: 14),

                  Text(
                    "ariyanto210@gmail.com",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // INFORMASI PENDUKUNG
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Icon(Icons.phone),

                SizedBox(width: 18),

                Text("081285431488"),

                Spacer(),

                Icon(Icons.location_on),

                SizedBox(width: 8),

                Text("Jakarta"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STATISTIK HORIZONTAL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "250+",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Produk Terjual"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Rating Toko"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DESKRIPSI NARATIF
          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Toko litrik Lengkap"
              "yang menyediakan berbagai kebutuhan Alat litrik "
              ,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 24),

          // VISUAL BRANDING
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage("assets/gaming.jpg"),
                  fit: BoxFit.cover,
                               ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}