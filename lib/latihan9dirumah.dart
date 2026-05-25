import 'package:flutter/material.dart';

void main() => runApp(Level3App());

// Model Class
class Produk {
  final String nama;
  final String deskripsi;
  final String gambar;

  Produk({required this.nama, required this.deskripsi, required this.gambar});
}

// Custom Widget
class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(
          produk.gambar,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(produk.nama),
        subtitle: Text(produk.deskripsi),
      ),
    );
  }
}

class Level3App extends StatelessWidget {
  final List<Produk> produkList = [
    Produk(
      nama: "Laptop",
      deskripsi: "Laptop gaming dengan spesifikasi tinggi",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Smartphone",
      deskripsi: "Ponsel terbaru dengan kamera canggih",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Headset",
      deskripsi: "Headset nirkabel untuk audio jernih",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Keyboard",
      deskripsi: "Keyboard mekanik RGB",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Mouse",
      deskripsi: "Mouse gaming presisi tinggi",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Monitor",
      deskripsi: "Monitor 27 inci Full HD",
      gambar: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7",
    ),
    Produk(
      nama: "Printer",
      deskripsi: "Printer laser warna",
      gambar: "https://via.placeholder.com/50",
    ),
    Produk(
      nama: "Power Bank",
      deskripsi: "Power bank 10000 mAh",
      gambar: "https://via.placeholder.com/50",
    ),
    Produk(
      nama: "Speaker",
      deskripsi: "Speaker bluetooth portabel",
      gambar: "https://via.placeholder.com/50",
    ),
    Produk(
      nama: "Router",
      deskripsi: "Router WiFi cepat",
      gambar: "https://via.placeholder.com/50",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Level 3: Model Class")),
        body: ListView.builder(
          itemCount: produkList.length,
          itemBuilder: (context, index) {
            return ItemProduk(produk: produkList[index]);
          },
        ),
      ),
    );
  }
}
