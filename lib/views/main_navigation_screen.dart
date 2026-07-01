import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/api_response.dart';
import '../model/batch_model.dart';
import '../model/user_model.dart';
import '../model/training_model.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';
import 'profile_screen.dart';
import 'dashboard_tab.dart';
import 'history_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const HistoryTab(),
    const PenggunaTab(),
    const BatchTab(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue.shade50,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.blue.shade300,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Batch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class PenggunaTab extends StatefulWidget {
  const PenggunaTab({super.key});

  @override
  State<PenggunaTab> createState() => _PenggunaTabState();
}

class _PenggunaTabState extends State<PenggunaTab> {
  bool _isLoading = true;
  List<UserModel> _users = [];
  Map<int, BatchModel> _batchMap = {};
  Map<int, TrainingModel> _trainingMap = {};
  String? _errorMsg;
  final _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final apiService = ApiService(createDioClient());
      
      final results = await Future.wait([
        apiService.getUsers(),
        apiService.getBatches(),
        apiService.getTrainings(),
      ]);

      final usersRes = results[0] as ApiResponse<List<UserModel>>;
      final batchesRes = results[1] as ApiResponse<List<BatchModel>>;
      final trainingsRes = results[2] as ApiResponse<List<TrainingModel>>;

      if (mounted) {
        setState(() {
          _users = usersRes.data ?? [];
          
          _batchMap = {
            for (var b in (batchesRes.data ?? [])) 
              if (b.id != null) b.id!: b
          };

          _trainingMap = {
            for (var t in (trainingsRes.data ?? [])) 
              if (t.id != null) t.id!: t
          };

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = e.toString();
        });
      }
    }
  }

  void _showUserDetails(UserModel user) {
    final userBatch = user.batchId != null ? _batchMap[user.batchId] : null;
    final userTraining = user.trainingId != null ? _trainingMap[user.trainingId] : null;

    final batchText = userBatch != null 
        ? (userBatch.batchKe != null ? "Batch ${userBatch.batchKe}" : userBatch.title ?? userBatch.name ?? "Batch ${userBatch.id}") 
        : "Belum terdaftar di Batch mana pun";

    final trainingText = userTraining != null 
        ? (userTraining.title ?? userTraining.name ?? "Training ID: ${userTraining.id}") 
        : "Belum memilih Pelatihan";

    showDialog(
      context: context,
      builder: (context) {
        final imgProvider = (user.profilePhoto != null && user.profilePhoto!.isNotEmpty)
            ? _getProfileImage(user.profilePhoto!)
            : null;
        return AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: imgProvider,
                      backgroundColor: Colors.white,
                      child: imgProvider == null ? const Icon(Icons.person, size: 28, color: Colors.blue) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Detail Pengguna",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.name ?? '-',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white30),
                const SizedBox(height: 12),
                _buildDetailRow("Email", user.email ?? '-', textColor: Colors.white),
                const SizedBox(height: 12),
                _buildDetailRow("Jenis Kelamin", user.jenisKelamin == 'L' ? "Laki-laki" : "Perempuan", textColor: Colors.white),
                const SizedBox(height: 12),
                _buildDetailRow("Batch Ikuti", batchText, textColor: Colors.white, isBold: true),
                const SizedBox(height: 12),
                _buildDetailRow("Pelatihan", trainingText, textColor: Colors.white, isBold: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor, bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11, 
            color: textColor?.withValues(alpha: 0.7) ?? Colors.grey, 
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengguna"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchCtrl.clear();
              setState(() {
                _searchQuery = "";
              });
              _loadData();
            },
          ),
        ],
      ),
      body: () {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_errorMsg != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Gagal memuat pengguna:\n$_errorMsg",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            ),
          );
        }
        if (_users.isEmpty) {
          return const Center(child: Text("Tidak ada pengguna terdaftar"));
        }

        final filteredUsers = _users.where((user) {
          final name = user.name?.toLowerCase() ?? "";
          final email = user.email?.toLowerCase() ?? "";
          final query = _searchQuery.toLowerCase();
          return name.contains(query) || email.contains(query);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari nama atau email...",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                      child: Text("Tidak ada pengguna dengan nama tersebut"),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final imgProvider = (user.profilePhoto != null && user.profilePhoto!.isNotEmpty)
                              ? _getProfileImage(user.profilePhoto!)
                              : null;
                          final userBatch = user.batchId != null ? _batchMap[user.batchId] : null;
                          final batchText = userBatch != null 
                              ? (userBatch.batchKe != null ? "Batch ${userBatch.batchKe}" : userBatch.title ?? userBatch.name ?? "Batch ${userBatch.id}") 
                              : "Belum masuk Batch";

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 1,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade50, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ListTile(
                                onTap: () => _showUserDetails(user),
                                leading: CircleAvatar(
                                  backgroundImage: imgProvider,
                                  child: imgProvider == null ? const Icon(Icons.person) : null,
                                ),
                                title: Text(user.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.email ?? '-'),
                                    const SizedBox(height: 2),
                                    Text(
                                      batchText, 
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: userBatch != null ? Colors.blue.shade600 : Colors.grey,
                                        fontWeight: userBatch != null ? FontWeight.w600 : FontWeight.normal
                                      )
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: user.jenisKelamin == 'L' ? Colors.blue.shade100 : Colors.pink.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.jenisKelamin == 'L' ? "Laki-laki" : "Perempuan",
                                    style: TextStyle(
                                      color: user.jenisKelamin == 'L' ? Colors.blue.shade900 : Colors.pink.shade900,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }(),
    );
  }
}

class BatchTab extends StatefulWidget {
  const BatchTab({super.key});

  @override
  State<BatchTab> createState() => _BatchTabState();
}

class _BatchTabState extends State<BatchTab> {
  late Future<ApiResponse<List<BatchModel>>> _batchesFuture;

  @override
  void initState() {
    super.initState();
    _batchesFuture = ApiService(createDioClient()).getBatches();
  }

  Future<void> _refresh() async {
    setState(() {
      _batchesFuture = ApiService(createDioClient()).getBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Batch"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<ApiResponse<List<BatchModel>>>(
        future: _batchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      "Gagal memuat batch:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              ),
            );
          }
          final batches = snapshot.data?.data ?? [];
          if (batches.isEmpty) {
            return const Center(child: Text("Tidak ada batch tersedia"));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: batches.length,
              itemBuilder: (context, index) {
                final batch = batches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              batch.title ?? (batch.batchKe != null ? "Batch ${batch.batchKe}" : null) ?? batch.name ?? "Batch ${batch.id}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "ID: ${batch.id}",
                                style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text("Periode:", style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 8),
                            Text(
                              "${batch.startDate ?? '-'} s/d ${batch.endDate ?? '-'}",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
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
