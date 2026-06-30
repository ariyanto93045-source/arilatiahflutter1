import 'dart:convert';
import 'dart:io';

import 'package:arilatiahflutter1/model35/models/profile_response.dart';
import 'package:arilatiahflutter1/model35/models/user_model.dart';
import 'package:arilatiahflutter1/model35/services/auth_service.dart';
import 'package:arilatiahflutter1/model35/services/dio_client.dart';
import 'package:arilatiahflutter1/model35/services/token_storage.dart';
import 'package:arilatiahflutter1/model35/views/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  late Future<ProfileResponse> _profileFuture;
  bool _isEditing = false;
  bool _isSaving = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
  }

  Future<ProfileResponse> _fetchProfile() async {
    final dio = createDioClient();
    final authService = AuthService(dio);
    final response = await authService.getProfile();

    if (mounted) {
      _nameController.text = response.data?.name ?? '';
      _emailController.text = response.data?.email ?? '';
    }
    return response;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final dio = createDioClient();
      final authService = AuthService(dio);

      final body = <String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      };

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        body['profile_photo'] = base64Image;
      }

      await authService.updateProfile(body);

      if (mounted) {
        setState(() {
          _isEditing = false;
          _selectedImage = null;
          _profileFuture = _fetchProfile();
        });
        _showMessage('Profil berhasil diperbarui');
      }
    } on DioException catch (e) {
      if (mounted) {
        _showMessage('Gagal memperbarui profil: ${_getErrorMessage(e)}');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await TokenStorage.clearToken();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  String _getErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.message ?? 'Terjadi kesalahan';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildProfileAvatar(UserModel user) {
    final photoValue = user.photoUrl;
    const apiBaseUrl = 'https://absensib1.mobileprojp.com';

    if (photoValue != null && photoValue.isNotEmpty) {
      if (photoValue.startsWith('http')) {
        return CircleAvatar(
          radius: 42,
          backgroundColor: Colors.white24,
          backgroundImage: NetworkImage(photoValue),
        );
      }

      try {
        final rawValue = photoValue.contains(',')
            ? photoValue.split(',').last
            : photoValue;
        final bytes = base64Decode(rawValue);
        return CircleAvatar(
          radius: 42,
          backgroundColor: Colors.white24,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {
        // If it is not a base64 string, fall back to a network path.
      }

      final normalizedPath = photoValue.startsWith('/')
          ? photoValue
          : '/$photoValue';
      return CircleAvatar(
        radius: 42,
        backgroundColor: Colors.white24,
        backgroundImage: NetworkImage('$apiBaseUrl$normalizedPath'),
      );
    }

    return const CircleAvatar(
      radius: 42,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, size: 42, color: Colors.white),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<ProfileResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Gagal memuat profil: ${snapshot.error}'),
              ),
            );
          }

          final user = snapshot.data?.data;
          if (user == null) {
            return const Center(child: Text('Profil tidak tersedia'));
          }

          if (_isEditing) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email wajib diisi';
                        }
                        if (!value.contains('@')) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const SizedBox(height: 140),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Pilih Foto'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _nameController.text = user.name ?? '';
                                _emailController.text = user.email ?? '';
                              });
                            },
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isSaving ? null : _updateProfile,
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade600, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(63, 81, 181, 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileAvatar(user),
                      const SizedBox(height: 12),
                      Text(
                        user.name ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email ?? '-',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Informasi Akun',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Nama'),
                    subtitle: Text(user.name ?? '-'),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(user.email ?? '-'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
