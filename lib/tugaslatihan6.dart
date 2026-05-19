import 'package:flutter/material.dart';

class tugas6 extends StatelessWidget {
  const tugas6({super.key});

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
            "KOSKU APP",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          // JUDUL LIST
          const Text(
            "Kelola Hunian Menjadi Lebih Simple dan Mudah ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 70),

          const Text(
            "Nomor Hp atau Email",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          // INPUT EMAIL
          TextField(
            decoration: InputDecoration(
              labelText: "Masukkan Email",
              border: OutlineInputBorder(), // buat kotak border
              prefixIcon: Icon(Icons.email),
            ),
          ),

          SizedBox(height: 15), // untuk batas border atas dan bawah
          const Text(
            "Password",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          const Text(
            "Lupa Password?",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          // INPUT NOMOR HP
          TextField(
            decoration: InputDecoration(
              labelText: "Masukkan Nomor HP",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          SizedBox(height: 15),

          SizedBox(height: 30),

          //  tombol masuk
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 114, 82, 255),
            ),
            onPressed: () {
              print("Tombol Masuk Ditekan");
            },
            child: Row(
              children: [Text("Masuk", style: TextStyle(color: Colors.white))Icon()],
            ),
            
          ),

          Text(
            "Daftar Pelanggan",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          // LIST TILE 1
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Andi Rahmat"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 2
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Budi Santoso"),
            subtitle: Text("Status: Non-Aktif"),
          ),

          // LIST TILE 3
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Citra Natalia"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 4
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Dewi Lestari"),
            subtitle: Text("Status: Aktif"),
          ),

          // LIST TILE 5
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Eko Prasetyo"),
            subtitle: Text("Status: Non-Aktif"),
          ),
        ],
      ),
    );
  }
}
