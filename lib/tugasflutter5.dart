import 'package:flutter/material.dart';

class StateFull extends StatefulWidget {
  const StateFull({super.key});

  @override
  State<StateFull> createState() => _StateFullState();
}

class _StateFullState extends State<StateFull> {
  bool tampilkan = false;
  bool suka = false;
  bool teks = false;
  int angka = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lab Interaksi Flutter"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 190, 115, 17),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 82, 255),
              ),
              onPressed: () {
                setState(() {
                  tampilkan = !tampilkan;
                });
              },
              child: Text(
                tampilkan ? "Bisa Kan !" : "Coba klik ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            IconButton(
              onPressed: () {
                setState(() {
                  suka = !suka;
                });
              },
              icon: Icon(
                Icons.favorite,
                color: suka
                    ? const Color.fromARGB(255, 244, 54, 212)
                    : const Color.fromARGB(255, 53, 1, 40),
              ),
            ),
            Text(
              suka ? "Bisa Kan !" : "Coba Klik sekali lagi",
              style: TextStyle(
                fontSize: 25,
                color: suka ? Colors.red : Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  teks = !teks;
                });
              },
              child: Text(
                teks ? "Sembunyikan" : "Tampilkan",
                style: TextStyle(fontSize: 25),
              ),
            ),
            teks
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Latihan ",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(221, 126, 40, 40),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox.shrink(),
            InkWell(
              splashColor: Colors.redAccent,
              onTap: () {
                print("Hasil dari di tombol");
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Image.asset(
                    "assets/images/KUcing lucu.jpg",
                    height: 100,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  angka++;
                });
                print("Di tekan sekali");
              },
              onDoubleTap: () {
                setState(() {
                  angka += 5;
                });
                print("Di tekan dua kali");
              },
              onLongPress: () {
                setState(() {
                  angka += 3;
                });
                print("Di tekan lama");
              },
              child: Container(
                child: Image.asset(
                  "assets/images/KUcing lucu.jpg",
                  height: 100,
                ),
              ),
            ),
            Text(
              angka.toString(),
              style: TextStyle(fontSize: 100, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            angka--;
          });
        },
        child: Icon(Icons.minimize_sharp),
      ),
    );
  }
}
