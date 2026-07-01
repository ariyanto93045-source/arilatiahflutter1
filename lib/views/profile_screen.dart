import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../login_screen.dart';
import '../preference_handler.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.getProfile();
      if (mounted) {
        setState(() {
          _user = response.data;
          _nameCtrl.text = _user?.name ?? '';
          _emailCtrl.text = _user?.email ?? '';
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String errorMsg = "Gagal mengambil data profil";
        final data = e.response?.data;
        errorMsg = data?['message'] ?? e.message ?? errorMsg;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengambil data profil: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Email tidak boleh kosong")),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.updateProfile({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Profil berhasil diperbarui")),
        );
        _fetchProfile(); // refresh
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String errorMsg = "Gagal memperbarui profil";
        final data = e.response?.data;
        if (e.response?.statusCode == 422 && data != null) {
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updatePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      final base64Image = "data:image/png;base64,$base64String";

      setState(() => _isLoading = true);
      try {
        final apiService = ApiService(createDioClient());
        final response = await apiService.updateProfilePhoto({
          'profile_photo': base64Image,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? "Photo updated")),
          );
          _fetchProfile();
        }
      } on DioException catch (e) {
        if (mounted) {
          String errorMsg = "Gagal memperbarui foto profil";
          final data = e.response?.data;
          if (e.response?.statusCode == 422 && data != null) {
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
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Terjadi kesalahan: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await PreferenceHandler.setLogin(false);
              await PreferenceHandler.removeToken();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil Logout")),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            (() {
              final imgProvider = (_user?.profilePhoto != null && _user!.profilePhoto!.isNotEmpty)
                  ? _getProfileImage(_user!.profilePhoto!)
                  : null;
              return CircleAvatar(
                radius: 50,
                backgroundImage: imgProvider,
                child: imgProvider == null ? const Icon(Icons.person, size: 50) : null,
              );
            })(),
            TextButton(
              onPressed: _updatePhoto, 
              child: Text(
                "Ubah Foto", 
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama",
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Profil",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ImageProvider? _getProfileImage(String? photoPath) {
  if (photoPath == null || photoPath.isEmpty) {
    return null;
  }

  // Clean localhost/127.0.0.1 in URLs
  var cleanPath = photoPath;
  if (cleanPath.contains('127.0.0.1:8000')) {
    cleanPath = cleanPath.replaceAll('http://127.0.0.1:8000', 'https://appabsensi.mobileprojp.com');
  } else if (cleanPath.contains('localhost')) {
    cleanPath = cleanPath.replaceAll('http://localhost:8000', 'https://appabsensi.mobileprojp.com');
    cleanPath = cleanPath.replaceAll('https://localhost:8000', 'https://appabsensi.mobileprojp.com');
    cleanPath = cleanPath.replaceAll('http://localhost', 'https://appabsensi.mobileprojp.com');
  }

  if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
    return NetworkImage(cleanPath);
  }

  if (cleanPath.startsWith('data:image') || cleanPath.contains(';base64,')) {
    try {
      final base64Str = cleanPath.split(',').last;
      return MemoryImage(base64Decode(base64Str));
    } catch (e) {
      debugPrint("Error decoding base64 image: $e");
      return null;
    }
  }

  // Check if it looks like base64 without headers
  final base64Regex = RegExp(r'^[a-zA-Z0-9+/=]+$');
  if (cleanPath.length > 100 && base64Regex.hasMatch(cleanPath)) {
    try {
      return MemoryImage(base64Decode(cleanPath));
    } catch (e) {
      debugPrint("Error decoding raw base64 image: $e");
    }
  }

  // Treat as relative URL
  final baseUrl = 'https://appabsensi.mobileprojp.com';
  final urlPath = cleanPath.startsWith('/') ? cleanPath : '/$cleanPath';
  return NetworkImage('$baseUrl$urlPath');
}
