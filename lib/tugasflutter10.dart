import 'package:flutter/material.dart';

void main() {}

// ==================
// HALAMAN FORM
// ==================
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // KEY FORM
  final _formKey = GlobalKey<FormState>();

  // CONTROLLER
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController hp = TextEditingController();
  TextEditingController kota = TextEditingController();

  // DIALOG
  void tampilDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Data Pendaftaran"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nama : ${nama.text}"),
              Text("Email : ${email.text}"),
              Text("HP : ${hp.text}"),
              Text("Kota : $selectedKota"),
            ],
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                // TUTUP DIALOG
                Navigator.pop(context);

                // PINDAH HALAMAN
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        HasilPage(nama: nama.text, kota: kota.text),
                  ),
                );
              },

              child: const Text("Lanjut"),
            ),
          ],
        );
      },
    );
  }

  String selectedKota = "Jakarta";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Tugas 10 Flutter"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(25),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: nama,

                decoration: const InputDecoration(
                  labelText: "Nama lengkap ",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama diisi dong ";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              // EMAIL
              TextFormField(
                controller: email,

                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jangan Lupa isi Email Ya";
                  }

                  if (!value.contains("@")) {
                    return "Email harus ada @";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // HP
              TextFormField(
                controller: hp,

                decoration: const InputDecoration(
                  labelText: "Nomor HP",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // KOTA
              DropdownButtonFormField<String>(
                initialValue: selectedKota,

                decoration: const InputDecoration(
                  labelText: "Kota Asal",
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(value: "Jakarta", child: Text("Jakarta")),

                  DropdownMenuItem(value: "Bandung", child: Text("Bandung")),

                  DropdownMenuItem(value: "Surabaya", child: Text("Surabaya")),

                  DropdownMenuItem(
                    value: "Yogyakarta",
                    child: Text("Yogyakarta"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedKota = value!;
                  });
                },
              ),

              // // TextFormField(
              // //   controller: kota,

              // //   decoration: const InputDecoration(
              // //     labelText: "Kota Asal",
              // //     border: OutlineInputBorder(),
              // //   ),

              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Kota wajib diisi";
              //     }

              //     return null;
              //   },
              // ),
              const SizedBox(height: 40),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 70,

                child: ElevatedButton(
                  onPressed: () {
                    // VALIDASI
                    if (_formKey.currentState!.validate()) {
                      tampilDialog();
                    }
                  },

                  child: const Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================
// HALAMAN HASIL
// ==================
class HasilPage extends StatelessWidget {
  final String nama;
  final String kota;

  const HasilPage({super.key, required this.nama, required this.kota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konfirmasi")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // gambar JEMPOL
            Image.asset(
              "assetimage/image/jempol gambar.png",
              width: 150,
              height: 150,
            ),

            SizedBox(height: 20),

            Text(
              "$nama dari $kota telah mendaftar.",
              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(title: const Text("Konfirmasi")),

    //     body: Center(
    //       child: Text(
    //         "Terima kasih, $nama dari $kota telah mendaftar.",
    //         textAlign: TextAlign.center,

    //         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   );
  }
}
