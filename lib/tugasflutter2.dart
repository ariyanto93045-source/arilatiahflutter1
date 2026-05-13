import 'package:flutter/material.dart';

class tugas extends StatelessWidget {
  const tugas ({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOKO LISTRIK"),
        titleTextStyle:  TextStyle(fontSize : 40,),
        backgroundColor: const Color.fromARGB(255, 64, 255, 80),
        centerTitle: true,
        
      ),
 // IDENTITAS UTAMA
          body: Column(
            children: [
              SizedBox(height:40),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 4, 170, 23),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.email, color: Color.fromARGB(255, 183, 58, 146)),

                  SizedBox(width: 20),

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

                SizedBox(width: 20),

                Text("081285431488"),

                Spacer(),

                Icon(Icons.location_on),

                SizedBox(width: 10),

                Text("Jakarta"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STATISTIK HORIZONTAL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 178, 183, 255),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "250+",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Produk Terjual"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 27, 104, 156),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Rating Toko"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DESKRIPSI NARATIF
          const SizedBox(height: 28),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Toko litrik Lengkap"
              "yang menyediakan berbagai kebutuhan Alat litrik "
              ,
              style: TextStyle(
                fontSize: 20,
                height: 1,
              ),
              textAlign: (TextAlign.justify),
            ),
          ),

          const SizedBox(height: 24),

          // MEREK TOKO
          Expanded(
            child: Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 156, 27),
                borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                  image: AssetImage("assetimage/image/bunga.jpg"),
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