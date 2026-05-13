import 'package:flutter/material.dart';

class tugas3 extends StatelessWidget {
  const tugas3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY MOM KOST"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),

            TextField(),
            Text(
              "Alamat email",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 2),

            TextField(),
            Text(
              "Nomor HP",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),

            TextField(),

            Text(
              "Diskripsi",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        "assetimage/image/bunga.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    const Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        "Kamar A1",
                        style: TextStyle(
                          color: Color.fromARGB(255, 10, 7, 7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // ITEM 2
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        "assetimage/image/bunga.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        "Kamar A2",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 10, 10, 10),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
