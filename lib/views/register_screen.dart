import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/api_response.dart';
import '../model/batch_model.dart';
import '../model/training_model.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController(text: "Budi");
  final _emailCtrl = TextEditingController(text: "admin@absensi.com");
  final _passCtrl = TextEditingController(text: "Password123!");

  String? _jenisKelamin = 'L'; // L or P
  int? _selectedBatchId;
  int? _selectedTrainingId;
  String? _base64Image;

  List<BatchModel> _batches = [];
  List<TrainingModel> _trainings = [];
  bool _isLoading = false;
  bool _isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final apiService = ApiService(createDioClient(requireAuth: false));

      final results = await Future.wait([
        apiService.getBatches().catchError((err) {
          debugPrint("Error fetching batches: $err");
          return ApiResponse<List<BatchModel>>(data: []);
        }),
        apiService.getTrainings().catchError((err) {
          debugPrint("Error fetching trainings: $err");
          return ApiResponse<List<TrainingModel>>(data: []);
        }),
      ]);

      final batchRes = results[0] as ApiResponse<List<BatchModel>>;
      final trainRes = results[1] as ApiResponse<List<TrainingModel>>;

      if (mounted) {
        setState(() {
          _batches = batchRes.data ?? [];
          _trainings = trainRes.data ?? [];
          if (_batches.isNotEmpty) _selectedBatchId = _batches.first.id;
          if (_trainings.isNotEmpty) _selectedTrainingId = _trainings.first.id;
          _isFetchingData = false;
        });
      }
    } catch (e) {
      debugPrint("Exception in _fetchDropdownData: $e");
      if (mounted) {
        setState(() => _isFetchingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil data batch/training")),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      setState(() {
        _base64Image =
            "data:image/png;base64,$base64String"; // Or infer type from extension
      });
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService(createDioClient(requireAuth: false));
      final response = await apiService.register({
        'name': _nameCtrl.text,
        'email': _emailCtrl.text,
        'password': _passCtrl.text,
        'jenis_kelamin': _jenisKelamin,
        'profile_photo': _base64Image ?? "",
        'batch_id': _selectedBatchId,
        'training_id': _selectedTrainingId,
      });

      if (response.data != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil! Silakan login."),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? "Registrasi gagal")),
          );
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMsg = "Registrasi gagal";
        final data = e.response?.data;
        if (e.response?.statusCode == 422 && data != null) {
          // Ambil semua pesan validasi dari field 'errors'
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
    if (_isFetchingData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Absensi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _jenisKelamin,
              decoration: const InputDecoration(labelText: "Jenis Kelamin"),
              items: const [
                DropdownMenuItem(value: 'L', child: Text("Laki-laki")),
                DropdownMenuItem(value: 'P', child: Text("Perempuan")),
              ],
              onChanged: (val) {
                setState(() => _jenisKelamin = val);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _selectedBatchId,
              decoration: const InputDecoration(labelText: "Batch"),
              items: _batches.map((b) {
                return DropdownMenuItem<int>(
                  value: b.id,
                  child: Text(
                    b.title ??
                        (b.batchKe != null ? "Batch ${b.batchKe}" : null) ??
                        b.name ??
                        "Batch ${b.id}",
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedBatchId = val);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _selectedTrainingId,
              decoration: const InputDecoration(labelText: "Training"),
              items: _trainings.map((t) {
                return DropdownMenuItem<int>(
                  value: t.id,
                  child: Text(t.title ?? t.name ?? "Training ${t.id}"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedTrainingId = val);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _base64Image == null
                        ? "Belum ada foto terpilih"
                        : "Foto terpilih!",
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Pilih Foto"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text("Daftar"),
                  ),
          ],
        ),
      ),
    );
  }
}
