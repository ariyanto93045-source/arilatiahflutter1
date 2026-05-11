import 'package:flutter/material.dart';

class tugas1flutter extends StatelessWidget {
  const tugas1flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Saya")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Lengkap
            Row(
               mainAxisAlignment: MainAxisAlignment.center,// untuk membungkus nama lengkap agar di tengah 
              children: [
                Text(
                  'Ariyanto',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            SizedBox(height: 15),

            // Kota dengan Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: const Color.fromARGB(255, 120, 54, 244),
                ),

                SizedBox(width: 5),

                Text(
                  'Jakarta',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            // Deskripsi Singkat
            Text(
              'Sugeng RAwuh ng Aplikasi Futter.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurpleAccent
                
              ),
              textAlign: TextAlign.center ,
              
            ),
        
          
        ],
      ),
    );
  }
}