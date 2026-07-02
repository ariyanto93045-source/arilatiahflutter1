import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../model/attendance_model.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';
import 'map_screen.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  bool _isLoading = true;
  List<AttendanceModel> _history = [];
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.getAttendanceHistory();
      if (mounted) {
        setState(() {
          _history = response.data ?? [];
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

  Future<void> _deleteAttendance(int id) async {
    setState(() => _isLoading = true);

    try {
      final apiService = ApiService(createDioClient());
      final response = await apiService.deleteAttendance(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Absensi berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        _loadHistory();
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final data = e.response?.data;
        final msg = data?['message'] ?? e.message ?? "Gagal menghapus absensi";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showDeleteConfirmDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Hapus Absensi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Apakah Anda yakin ingin menghapus data absensi ini?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                _deleteAttendance(id);
              },
              child: const Text(
                "Hapus",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openMap(double lat, double lng, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapScreen(latitude: lat, longitude: lng, title: title),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMM yyyy', 'id_ID').format(parsedDate);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatAddress(String? address, double? lat, double? lng) {
    if (address == null || address.isEmpty) return '-';
    final lowerAddress = address.toLowerCase();
    
    // Check if it's the default emulator Google address (Mountain View/Amphitheatre)
    if (lowerAddress.contains("mountain view") || 
        lowerAddress.contains("amphitheatre") ||
        lowerAddress.contains("1600 amphitheatre") ||
        (lat != null && lat.toStringAsFixed(3) == "37.422")) {
      return "PPKD Jakarta Pusat (Simulasi)";
    }
    
    // If within 150m of PPKD Jakarta Pusat, force prefixing "PPKD Jakarta Pusat"
    if (lat != null && lng != null) {
      final distance = Geolocator.distanceBetween(
        lat,
        lng,
        -6.2114,
        106.8189,
      );
      if (distance <= 150) {
        return "PPKD Jakarta Pusat, $address";
      }
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMsg != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 54, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  "Gagal memuat riwayat:\n$_errorMsg",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadHistory,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: _history.isEmpty
            ? const Center(child: Text("Belum ada riwayat absensi"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  final attendance = _history[index];
                  final formattedDate = _formatDate(attendance.attendanceDate);

                  final isIzin =
                      attendance.status?.toLowerCase() == "izin" ||
                      attendance.status?.toLowerCase() == "sakit" ||
                      (attendance.alasanIzin != null &&
                          attendance.alasanIzin!.trim().isNotEmpty);
                  final isSakit =
                      attendance.alasanIzin?.toLowerCase() == "sakit" ||
                      attendance.status?.toLowerCase() == "sakit";

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isIzin
                              ? (isDark
                                  ? [const Color(0xFF2D1F10), const Color(0xFF1F150A)]
                                  : [Colors.orange.shade50, Colors.white])
                              : (isDark
                                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                  : [Colors.blue.shade50, Colors.white]),
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
                                isIzin
                                    ? "Tanggal Izin: $formattedDate"
                                    : formattedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  if (isIzin)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSakit
                                            ? (isDark ? Colors.red.shade900.withOpacity(0.4) : Colors.red.shade100)
                                            : (isDark ? Colors.orange.shade900.withOpacity(0.4) : Colors.orange.shade100),
                                        borderRadius: BorderRadius.circular(12),
                                        border: isDark ? Border.all(
                                          color: isSakit ? Colors.red.shade700 : Colors.orange.shade700,
                                        ) : null,
                                      ),
                                      child: Text(
                                        isSakit ? "Sakit" : "Izin",
                                        style: TextStyle(
                                          color: isSakit
                                              ? (isDark ? Colors.red.shade200 : Colors.red.shade900)
                                              : (isDark ? Colors.orange.shade200 : Colors.orange.shade900),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  if (attendance.id != null)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () => _showDeleteConfirmDialog(
                                        attendance.id!,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Divider(color: isDark ? Colors.white12 : Colors.grey.shade300),
                          const SizedBox(height: 6),
                          if (isIzin) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isSakit ? Icons.local_hospital : Icons.info,
                                  color: isSakit
                                      ? (isDark ? Colors.red.shade300 : Colors.red.shade800)
                                      : (isDark ? Colors.orange.shade300 : Colors.orange.shade800),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSakit
                                            ? "Alasan Sakit:"
                                            : "Alasan Izin:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        attendance.alasanIzin ?? '-',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSakit
                                              ? (isDark ? Colors.red.shade300 : Colors.red.shade900)
                                              : (isDark ? Colors.orange.shade300 : Colors.orange.shade900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Check In:",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        attendance.checkInTime ?? '-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                                        ),
                                      ),
                                      if (attendance.checkInAddress !=
                                          null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatAddress(
                                            attendance.checkInAddress,
                                            attendance.checkInLat,
                                            attendance.checkInLng,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.grey.shade300 : Colors.black54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (attendance.checkInLat != null &&
                                    attendance.checkInLng != null)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.map_outlined,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _openMap(
                                      attendance.checkInLat!,
                                      attendance.checkInLng!,
                                      "Lokasi Masuk $formattedDate",
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Check Out:",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        attendance.checkOutTime ?? '-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
                                        ),
                                      ),
                                      if (attendance.checkOutAddress !=
                                          null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatAddress(
                                            attendance.checkOutAddress,
                                            attendance.checkOutLat,
                                            attendance.checkOutLng,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.grey.shade300 : Colors.black54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (attendance.checkOutLat != null &&
                                    attendance.checkOutLng != null)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.map_outlined,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _openMap(
                                      attendance.checkOutLat!,
                                      attendance.checkOutLng!,
                                      "Lokasi Pulang $formattedDate",
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
