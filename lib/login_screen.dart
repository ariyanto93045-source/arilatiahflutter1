import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../preference_handler.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';
import 'homescreen.dart';
import 'views/register_screen.dart'; // We will create this

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: "projecthabibie@gmail.com");
  final _passCtrl = TextEditingController(text: "Password123");
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.login({
        'email': _emailCtrl.text,
        'password': _passCtrl.text,
      });

      if (response.data != null && response.data?.token != null) {
        await PreferenceHandler.setLogin(true);
        await PreferenceHandler.setToken(response.data!.token!);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? "Login failed")),
          );
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMsg = "Login gagal";
        final data = e.response?.data;
        if (e.response?.statusCode == 401) {
          errorMsg = data?['message'] ?? "Email atau password salah";
        } else if (e.response?.statusCode == 404) {
          errorMsg = data?['message'] ?? "Email belum terdaftar";
        } else if (e.response?.statusCode == 422 && data != null) {
          final errors = data['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            errorMsg = errors.values
                .map((v) => (v as List).join(', '))
                .join('\n');
          } else {
            errorMsg = data['message'] ?? errorMsg;
          }
        } else {
          errorMsg = data?['message'] ?? e.message ?? errorMsg;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Absensi PPKD B6")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text("Login")),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Belum punya akun? Daftar disini"),
            ),
          ],
        ),
      ),
    );
  }
}
