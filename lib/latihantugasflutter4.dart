import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text(
          "MY MOM KOS",
          style: TextStyle(color: Colors.redAccent),
        ),

        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      // LISTVIEW SEBAGAI ROOT
      body: ListView(
        padding: const EdgeInsets.all(15),

        children: [
          // JUDUL FORM
          const Text(
            "Masukkan Nama Penyewa",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 25),

          // INPUT NAMA
          const TextField(
            decoration: InputDecoration(
              labelText: "Masukkan Nama",
              border: OutlineInputBorder(), //bikinn kotak border
              prefixIcon: Icon(Icons.person), // buat icon manusia
            ),
          ),

          const SizedBox(height: 15),

          // INPUT EMAIL
          const TextField(
            decoration: InputDecoration(
              labelText: "Masukkan Email",
              border: OutlineInputBorder(), // buat kotak border
              prefixIcon: Icon(Icons.email),
            ),
          ),

          const SizedBox(height: 15), // untuk batas border atas dan bawah
          // INPUT NOMOR HP
          const TextField(
            decoration: InputDecoration(
              labelText: "Masukkan Nomor HP",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 15),

          // INPUT DESKRIPSI
          const TextField(
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Pilih Pekerjaan",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
          ),

          const SizedBox(height: 30),

          // JUDUL LIST
          const Text(
            "Daftar Pelanggan",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // LIST TILE 1
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Andi Rahmat"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 2
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Budi Santoso"),
            subtitle: Text("Status: Non-Aktif"),
          ),

          // LIST TILE 3
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Citra Natalia"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 4
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Dewi Lestari"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 5
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Eko Prasetyo"),
            subtitle: Text("Status: Non-Aktif"),
          ),
        ],
      ),
    );
  }
}
