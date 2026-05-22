import 'package:flutter/material.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: InputInteraktif(),
//     );
//   }

// }

class InputInteraktif extends StatefulWidget {
  const InputInteraktif({super.key});

  @override
  State<InputInteraktif> createState() => _InputInteraktifState();
}

// class _InputInteraktifState extends State<InputInteraktif> {

//   // INDEX BOTTOM NAVIGATION
//   int _selectedIndex = 0;

//   // DAFTAR HALAMAN
//   static const List<Widget> _widgetOptions = <Widget>[

//     Center(
//       child: Text(
//         'Halaman Home',
//         style: TextStyle(fontSize: 30),
//       ),
//     ),

//     Center(
//       child: Text(
//         'Halaman Business',
//         style: TextStyle(fontSize: 30),
//       ),
//     ),

//     Center(
//       child: Text(
//         'Halaman School',
//         style: TextStyle(fontSize: 30),
//       ),
//     ),
//   ];

//   // FUNGSI PINDAH HALAMAN
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       // APPBAR
//       appBar: AppBar(
//         title: const Text("MY MOM KOS"),
//         backgroundColor: Colors.green,
//       ),

//       // BODY
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),

//       // BOTTOM NAVIGATION
//       bottomNavigationBar: BottomNavigationBar(

//         items: const <BottomNavigationBarItem>[

//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Business',
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             label: 'School',
//           ),
//         ],

//         currentIndex: _selectedIndex,

//         selectedItemColor: Colors.amber,

//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

class _InputInteraktifState extends State<InputInteraktif> {
  // CHECKBOX
  bool setuju = false;
  // SWITCH
  bool modeGelap = false;
  // DROPDOWN
  String kategori = "Elektronik";
  // DATE
  DateTime? tanggalLahir;
  // TIME
  TimeOfDay? waktuPengingat;
  // FORMAT TANGGAL
  String formatTanggal(DateTime tanggal) {
    return "${tanggal.day.toString().padLeft(2, '0')}-"
        "${tanggal.month.toString().padLeft(2, '0')}-"
        "${tanggal.year}";
  }

  // FORMAT JAM
  String formatJam(TimeOfDay waktu) {
    return "${waktu.hour.toString().padLeft(2, '0')}:"
        "${waktu.minute.toString().padLeft(2, '0')}";
  }

  // // INDEX BOTTOM NAVIGATION
  // int _selectedIndex = 0;

  // // DAFTAR HALAMAN
  // static const List<Widget> _widgetOptions = <Widget>[
  //   // InputInteraktif(),
  //   tugas8(),
  // ];

  // // FUNGSI PINDAH HALAMAN
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("Input Interaktif"),
        backgroundColor: modeGelap
            ? Colors.black
            : const Color.fromARGB(255, 159, 133, 206),
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),

              child: Center(
                child: Text(
                  "MENU INPUT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.check_box),
              title: Text("Syarat & Ketentuan"),
            ),

            ListTile(leading: Icon(Icons.dark_mode), title: Text("Mode Gelap")),

            ListTile(
              leading: Icon(Icons.category),
              title: Text("Kategori Produk"),
            ),

            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Pilih Tanggal"),
            ),

            ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Atur Pengingat"),
            ),
          ],
        ),
      ),

      // BODY
      body: Container(
        width: double.infinity,

        color: modeGelap ? Colors.grey[900] : Colors.white,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Center(child: _widgetOptions.elementAt(_selectedIndex)),
                // =====================
                // CHECKBOX
                // =====================
                const Text(
                  "1. Syarat & Ketentuan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                CheckboxListTile(
                  value: setuju,

                  title: const Text("Saya menyetujui persyaratan"),

                  onChanged: (value) {
                    setState(() {
                      setuju = value!;
                    });
                  },
                ),

                Text(
                  setuju
                      ? "Pendaftaran diperbolehkan"
                      : "Pendaftaran belum tersedia",

                  style: TextStyle(
                    fontSize: 16,
                    color: modeGelap ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // =====================
                // SWITCH
                // =====================
                const Text(
                  "2. Mode Tampilan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SwitchListTile(
                  value: modeGelap,

                  title: const Text("Aktifkan Mode Gelap"),

                  onChanged: (value) {
                    setState(() {
                      modeGelap = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                // =====================
                // DROPDOWN
                // =====================
                const Text(
                  "3. Kategori Produk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                DropdownButton<String>(
                  value: kategori,
                  isExpanded: true,

                  items: const [
                    DropdownMenuItem(
                      value: "Elektronik",
                      child: Text("Elektronik"),
                    ),

                    DropdownMenuItem(value: "Pakaian", child: Text("Pakaian")),

                    DropdownMenuItem(value: "Makanan", child: Text("Makanan")),

                    DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                  ],

                  onChanged: (value) {
                    setState(() {
                      kategori = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                Text(
                  "Anda memilih kategori: $kategori",

                  style: TextStyle(
                    fontSize: 16,
                    color: modeGelap ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // =====================
                // DATE PICKER
                // =====================
                const Text(
                  "4. Pilih Tanggal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,

                      initialDate: DateTime.now(),

                      firstDate: DateTime(2000),

                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        tanggalLahir = pickedDate;
                      });
                    }
                  },

                  child: const Text("Pilih Tanggal"),
                ),

                const SizedBox(height: 10),

                Text(
                  tanggalLahir == null
                      ? "Tanggal belum dipilih"
                      : "Tanggal Lahir: ${formatTanggal(tanggalLahir!)}",

                  style: TextStyle(
                    fontSize: 16,
                    color: modeGelap ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // =====================
                // TIME PICKER
                // =====================
                const Text(
                  "5. Atur Pengingat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        waktuPengingat = pickedTime;
                      });
                    }
                  },

                  child: const Text("Pilih Waktu"),
                ),

                const SizedBox(height: 10),

                Text(
                  waktuPengingat == null
                      ? "Pengingat belum diatur"
                      : "Pengingat diatur pukul: ${formatJam(waktuPengingat!)}",

                  style: TextStyle(
                    fontSize: 16,
                    color: modeGelap ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                // =====================
                // RESULT AREA
                // =====================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: modeGelap ? Colors.black : Colors.green[100],

                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "HASIL INPUT",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Persetujuan: ${setuju ? "Setuju" : "Belum Setuju"}",
                      ),

                      Text("Mode: ${modeGelap ? "Gelap" : "Terang"}"),

                      Text("Kategori: $kategori"),

                      Text(
                        tanggalLahir == null
                            ? "Tanggal: Belum dipilih"
                            : "Tanggal: ${formatTanggal(tanggalLahir!)}",
                      ),

                      Text(
                        waktuPengingat == null
                            ? "Pengingat: Belum diatur"
                            : "Pengingat: ${formatJam(waktuPengingat!)}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // // / BOTTOM NAVIGATION
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Rumah'),

      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),

      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
      //   ],

      //   currentIndex: _selectedIndex,

      //   selectedItemColor: Colors.amber,

      //   onTap: _onItemTapped,
      // ),
    );
  }
}
