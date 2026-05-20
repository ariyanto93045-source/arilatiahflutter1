import 'package:arilatiahflutter1/Tugasflutter1.dart';
import 'package:arilatiahflutter1/extension/navigator.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const contoh());
// }

class Contoh extends StatelessWidget {
  const Contoh({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              children: [
                // CONTENT
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // LOGO
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.apartment,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // TITLE
                      const Text(
                        "MY MOM'S KOST",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Kelola hunian jadi lebih efisien dan\nmodern.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),

                      const SizedBox(height: 40),

                      // LABEL EMAIL
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nomor HP atau Email",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // TEXTFIELD EMAIL
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Contoh: 08123456789 atau user@email.com",
                          prefixIcon: const Icon(Icons.person_outline),

                          filled: true,
                          fillColor: const Color(0xfff7f2fb),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // PASSWORD ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Password", style: TextStyle(fontSize: 18)),

                          Text(
                            "Lupa Password?",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // PASSWORD FIELD
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Masukkan password Anda",

                          prefixIcon: const Icon(Icons.lock_outline),

                          suffixIcon: const Icon(Icons.visibility_outlined),

                          filled: true,
                          fillColor: const Color(0xfff7f2fb),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // BUTTON LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 60,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          onPressed: () {
                            context.push(tugas1flutter());
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Masuk",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(width: 10),

                              Icon(Icons.login, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // DIVIDER
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "ATAU",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // BUTTON SOCIAL
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},

                              icon: const Icon(
                                Icons.g_mobiledata,
                                color: Colors.black,
                              ),

                              label: const Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),

                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},

                              icon: const Icon(
                                Icons.facebook,
                                color: Colors.blue,
                              ),

                              label: const Text(
                                "Facebook",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),

                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),
                    ],
                  ),
                ),

                // FOOTER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  decoration: const BoxDecoration(
                    color: Color(0xfff7f2fb),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(fontSize: 18),
                      ),

                      Icon(
                        Icons.app_registration,
                        color: Colors.deepPurple,
                        size: 20,
                      ),

                      SizedBox(width: 5),

                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
