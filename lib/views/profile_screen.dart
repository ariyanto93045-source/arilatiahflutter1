import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchProfile();
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
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching profile: $e")));
      }
    }
  }

  Future<void> _updateName() async {
    if (_nameCtrl.text.isEmpty) return;
    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.updateProfile({'name': _nameCtrl.text});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Profile updated")),
        );
        _fetchProfile(); // refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
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
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error updating photo: $e")));
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
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_user?.profilePhoto != null && _user!.profilePhoto!.isNotEmpty)
              CircleAvatar(
                radius: 50,
                // In real app, might need to handle base64 vs url
                // Assuming url for now, or base64 decoding if needed
                backgroundImage: _user!.profilePhoto!.startsWith('http')
                    ? NetworkImage(_user!.profilePhoto!) as ImageProvider
                    : MemoryImage(
                        base64Decode(_user!.profilePhoto!.split(',').last),
                      ),
              )
            else
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            TextButton(onPressed: _updatePhoto, child: const Text("Ubah Foto")),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 8),
            Text("Email: ${_user?.email ?? '-'}"),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateName,
              child: const Text("Update Nama"),
            ),
          ],
        ),
      ),
    );
  }
}
