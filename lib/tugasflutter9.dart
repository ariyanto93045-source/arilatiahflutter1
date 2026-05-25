import 'package:flutter/material.dart';

void main() {}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 26, 116, 86),
          title: const Text("Tugas 9 Flutter"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Level 1"),
              Tab(text: "Level 2"),
              Tab(text: "Level 3"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [Level1Page(), Level2Page(), Level3Page()],
        ),
      ),
    );
  }
}

//
// =====================================================
// LEVEL 1
// List<String>
// =====================================================
//

class Level1Page extends StatelessWidget {
  const Level1Page({super.key});

  // LIST STRING
  final List<String> kategori = const [
    "Buah-buahan",
    "Sayuran",
    "Elektronik",
    "Pakaian Pria",
    "Pakaian Wanita",
    "ATK",
    "Buku & Majalah",
    "Peralatan Dapur",
    "Makanan Ringan",
    "Minuman",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kategori.length,

      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.category),
          title: Text(kategori[index]),
        );
      },
    );
  }
}

//
// =====================================================
// LEVEL 2
// List<Map<String, dynamic>>
// =====================================================
//

class Level2Page extends StatelessWidget {
  const Level2Page({super.key});

  // LIST MAP
  final List<Map<String, dynamic>> kategoriData = const [
    {"nama": "Buah-buahan", "icon": Icons.apple},
    {"nama": "Sayuran", "icon": Icons.eco},
    {"nama": "Elektronik", "icon": Icons.electrical_services},
    {"nama": "Pakaian Pria", "icon": Icons.man},
    {"nama": "Pakaian Wanita", "icon": Icons.woman},
    {"nama": "ATK", "icon": Icons.edit},
    {"nama": "Buku", "icon": Icons.book},
    {"nama": "Peralatan Dapur", "icon": Icons.kitchen},
    {"nama": "Makanan Ringan", "icon": Icons.fastfood},
    {"nama": "Minuman", "icon": Icons.local_drink},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kategoriData.length,

      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(kategoriData[index]["icon"]),
          title: Text(kategoriData[index]["nama"]),
        );
      },
    );
  }
}

//
// =====================================================
// LEVEL 3
// MODEL CLASS
// =====================================================
//

// MODEL PRODUK
class Produk {
  final String nama;
  final String gambar;
  final String deskripsi;

  Produk({required this.nama, required this.gambar, required this.deskripsi});
}

class Level3Page extends StatelessWidget {
  const Level3Page({super.key});

  // DATA PRODUK
  List<Produk> get daftarProduk => [
    Produk(
      nama: "Laptop",
      gambar: "assetimage/image/laptop.jpg",
      deskripsi: "Laptop untuk belajar dan kerja",
    ),
    Produk(
      nama: "Keyboard",
      gambar: "assetimage/image/keyboard.jpg",
      deskripsi: "Keyboard gaming RGB",
    ),
    Produk(
      nama: "Mouse",
      gambar: "assetimage/image/mouse.jpg",
      deskripsi: "Mouse wireless modern",
    ),
    Produk(
      nama: "Monitor",
      gambar: "assetimage/image/monitor modern.jpg",
      deskripsi: "Monitor Full HD",
    ),
    Produk(
      nama: "Printer",
      gambar: "assetimage/image/printer.jpg",
      deskripsi: "Printer warna cepat",
    ),
    Produk(
      nama: "Speaker",
      gambar: "assetimage/image/speker modern.jpg",
      deskripsi: "Speaker suara bass",
    ),
    Produk(
      nama: "Headset",
      gambar: "assetimage/image/head seat.jpg",
      deskripsi: "Headset nyaman dipakai",
    ),
    Produk(
      nama: "Webcam",
      gambar: "assetimage/image/webcam.jpg",
      deskripsi: "Webcam untuk meeting",
    ),
    Produk(
      nama: " HArdis Eksternal",
      gambar: "assetimage/image/hardisk ekternal.jpg",
      deskripsi: "Penyimpanan data portable",
    ),
    Produk(
      nama: "VGA ",
      gambar: "assetimage/image/mouse.jpg",
      deskripsi: "VGA 8 GB",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daftarProduk.length,

      itemBuilder: (context, index) {
        return ItemProduk(produk: daftarProduk[index]);
      },
    );
  }
}

//
// =====================================================
// CUSTOM WIDGET
// =====================================================
//

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Row(
          children: [
            // GAMBAR
            Image.network(
              produk.gambar,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),

            const SizedBox(width: 10),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(produk.deskripsi),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
