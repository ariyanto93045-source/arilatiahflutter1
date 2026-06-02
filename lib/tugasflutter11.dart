import 'package:flutter/material.dart';

import 'database_helper11.dart';
import 'modeluser11.dart';

class Tugas extends StatefulWidget {
  const Tugas({super.key});

  @override
  State<Tugas> createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nama = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController hp = TextEditingController();

  TextEditingController password = TextEditingController();

  void register() async {
    final userEmail = email.text.trim();
    final userPassword = password.text;
    final userNama = nama.text;
    final userhp = hp.text;

    if (userEmail.isEmpty || userPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi semua field bro!')));
      return;
    }

    final user = User(
      nama: userNama,
      hp: userhp,
      email: userEmail,
      pasword: userPassword,
    );
    bool success = await DBHelper().registerUser(user);
    // Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat')));
      setState(() {});
      // Tambahkan navigasi ke halaman login jika perlu
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!')));
    }

    Future<List<User>> getData() {
      return DBHelper().getAllUsers();
    }

    Future simpanData() async {
      if (formKey.currentState!.validate()) {
        User user = User(
          nama: nama.text,
          email: email.text,
          hp: hp.text,
          pasword: password.text,
        );

        await DBHelper().registerUser(user);

        nama.clear();
        email.clear();
        hp.clear();
        password.clear();

        setState(() {});

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Data Berhasil Disimpan")));
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Pendaftaran User")),

        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              Form(
                key: formKey,

                child: Column(
                  children: [
                    TextFormField(
                      controller: nama,
                      decoration: const InputDecoration(labelText: "Nama"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nama wajib diisi";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email wajib diisi";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: hp,
                      decoration: const InputDecoration(labelText: "Nomor HP"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "HP wajib diisi";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password disi";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: simpanData,
                      child: const Text("SIMPAN"),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child: FutureBuilder<List<User>>(
                  future: getData(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var data = snapshot.data!;

                    if (data.isEmpty) {
                      return const Center(child: Text("Belum ada data"));
                    }

                    return ListView.builder(
                      itemCount: data.length,

                      itemBuilder: (context, index) {
                        User user = data[index];

                        return Card(
                          child: ListTile(
                            title: Text(user.nama),

                            subtitle: Text(
                              "${user.email}\n${user.hp}\n${user.pasword}",
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
