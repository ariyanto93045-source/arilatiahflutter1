import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'model/training_model.dart';
import 'preference_handler.dart';
import 'services/api_service.dart';
import 'services/dio_client.dart';
import 'views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TrainingModel> _trainings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
  }

  Future<void> _fetchTrainings() async {
    try {
      final apiService = ApiService(createDioClient());
      final res = await apiService.getTrainings();
      if (mounted) {
        setState(() {
          _trainings = res.data ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengambil data pelatihan")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home - PPKD B6"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              await PreferenceHandler.setLogin(false);
              await PreferenceHandler.removeToken();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Daftar Pelatihan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _trainings.length,
                    itemBuilder: (context, index) {
                      final t = _trainings[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(t.id.toString())),
                        title: Text(t.title ?? t.name ?? '-'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
