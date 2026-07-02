import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../model/user_model.dart';
import '../model/attendance_model.dart';
import '../model/attendance_stats_model.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool _isLoading = true;
  UserModel? _user;
  AttendanceStatsModel? _stats;
  AttendanceModel? _todayAttendance;
  String? _errorMsg;

  Position? _currentPosition;
  GoogleMapController? _mapController;
  bool _useSimulatedLocation = false;
  double? _distanceToPPKD;

  static const double ppkdLatitude = -6.2114;
  static const double ppkdLongitude = 106.8189;
  static const String ppkdAddress = "PPKD Jakarta Pusat, Jl. Karet Pasar Baru Barat V No. 23, Karet Tengsin, Tanah Abang, Jakarta Pusat";

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _determineCurrentPosition();
  }

  Future<void> _determineCurrentPosition() async {
    try {
      final pos = await _getCurrentLocation();
      if (pos != null && mounted) {
        setState(() {
          _currentPosition = pos;
          _calculateDistance();
        });
      }
    } catch (e) {
      debugPrint("Error determining location: $e");
    }
  }

  void _calculateDistance() {
    if (_currentPosition != null) {
      setState(() {
        _distanceToPPKD = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          ppkdLatitude,
          ppkdLongitude,
        );
      });
    }
  }

  Set<Marker> _getMarkers() {
    final Set<Marker> markers = {};
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: _useSimulatedLocation
              ? const LatLng(ppkdLatitude, ppkdLongitude)
              : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: InfoWindow(title: _useSimulatedLocation ? "Lokasi Saya (Simulasi)" : "Lokasi Saya"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    
    markers.add(
      const Marker(
        markerId: MarkerId('ppkd_location'),
        position: LatLng(ppkdLatitude, ppkdLongitude),
        infoWindow: InfoWindow(title: "PPKD Jakarta Pusat", snippet: ppkdAddress),
      ),
    );
    return markers;
  }

  Set<Circle> _getCircles() {
    return {
      Circle(
        circleId: const CircleId('ppkd_radius'),
        center: const LatLng(ppkdLatitude, ppkdLongitude),
        radius: 100, // 100 meters geofence radius
        fillColor: Colors.blue.withOpacity(0.15),
        strokeColor: Colors.blue.shade700,
        strokeWidth: 2,
      ),
    };
  }

  void _showGeofenceErrorDialog(double distance) {
    String distanceStr = distance > 1000 
        ? "${(distance / 1000).toStringAsFixed(2)} km" 
        : "${distance.toStringAsFixed(1)} meter";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.gpp_bad, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text("Di Luar Area Absensi", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Anda berada di luar radius PPKD Jakarta Pusat.\n\n"
          "Jarak Anda saat ini: $distanceStr.\n"
          "Radius maksimal untuk absen: 100 meter.\n\n"
          "Silakan mendekat ke lokasi PPKD Jakarta Pusat atau aktifkan opsi 'Simulasi Lokasi PPKD' untuk keperluan uji coba.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _useSimulatedLocation = true;
              });
              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    const LatLng(ppkdLatitude, ppkdLongitude),
                    16.5,
                  ),
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Simulasi Lokasi PPKD Jakarta Pusat diaktifkan."),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text("Aktifkan Simulasi"),
          ),
        ],
      ),
    );
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final street = place.street ?? '';
        final subLocality = place.subLocality ?? '';
        final locality = place.locality ?? '';
        final subAdmin = place.subAdministrativeArea ?? '';
        return [street, subLocality, locality, subAdmin]
            .where((str) => str.isNotEmpty)
            .join(', ');
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    }
    return "Jakarta";
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final apiService = ApiService(createDioClient());
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      UserModel? user;
      try {
        final res = await apiService.getProfile();
        user = res.data;
      } catch (e) {
        debugPrint("Error fetching profile: $e");
      }

      AttendanceStatsModel? stats;
      try {
        final res = await apiService.getAttendanceStats();
        stats = res.data;
      } catch (e) {
        debugPrint("Error fetching stats: $e");
      }

      AttendanceModel? todayAttendance;
      try {
        final res = await apiService.getTodayAttendance(todayStr);
        todayAttendance = res.data;
      } catch (e) {
        debugPrint("Error fetching today attendance: $e");
      }

      if (mounted) {
        setState(() {
          _user = user;
          _stats = stats;
          _todayAttendance = todayAttendance;
          _isLoading = false;
        });
      }
      _determineCurrentPosition();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = e.toString();
        });
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Layanan lokasi (GPS) mati. Silakan aktifkan GPS terlebih dahulu.")),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akses izin lokasi ditolak.")),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akses lokasi ditolak permanen. Aktifkan manual di Pengaturan.")),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<void> _performCheckIn(String status, String? alasan) async {
    Navigator.pop(context); // Close dialog
    setState(() => _isLoading = true);

    try {
      double checkInLat;
      double checkInLng;
      String address;

      if (_useSimulatedLocation) {
        checkInLat = ppkdLatitude;
        checkInLng = ppkdLongitude;
        address = ppkdAddress;
      } else {
        final pos = await _getCurrentLocation();
        if (pos == null) {
          setState(() => _isLoading = false);
          return;
        }
        checkInLat = pos.latitude;
        checkInLng = pos.longitude;
        address = await _getAddressFromLatLng(pos.latitude, pos.longitude);

        if (status == "masuk") {
          final distance = Geolocator.distanceBetween(
            checkInLat,
            checkInLng,
            ppkdLatitude,
            ppkdLongitude,
          );
          if (distance > 100) {
            setState(() => _isLoading = false);
            _showGeofenceErrorDialog(distance);
            return;
          }
        }
      }

      final todayDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final nowTimeStr = DateFormat('HH:mm').format(DateTime.now());

      final apiService = ApiService(createDioClient());
      final response = await apiService.checkIn({
        'attendance_date': todayDateStr,
        'check_in': nowTimeStr,
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_in_address': address,
        'status': status,
        'alasan_izin': alasan,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Absen masuk berhasil"),
            backgroundColor: Colors.green,
          ),
        );
        _loadDashboardData();
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final data = e.response?.data;
        final msg = data?['message'] ?? e.message ?? "Gagal absen masuk";
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

  Future<void> _performCheckOut() async {
    setState(() => _isLoading = true);

    try {
      double checkOutLat;
      double checkOutLng;
      String address;

      if (_useSimulatedLocation) {
        checkOutLat = ppkdLatitude;
        checkOutLng = ppkdLongitude;
        address = ppkdAddress;
      } else {
        final pos = await _getCurrentLocation();
        if (pos == null) {
          setState(() => _isLoading = false);
          return;
        }
        checkOutLat = pos.latitude;
        checkOutLng = pos.longitude;
        address = await _getAddressFromLatLng(pos.latitude, pos.longitude);

        final distance = Geolocator.distanceBetween(
          checkOutLat,
          checkOutLng,
          ppkdLatitude,
          ppkdLongitude,
        );
        if (distance > 100) {
          setState(() => _isLoading = false);
          _showGeofenceErrorDialog(distance);
          return;
        }
      }

      final todayDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final nowTimeStr = DateFormat('HH:mm').format(DateTime.now());

      final apiService = ApiService(createDioClient());
      final response = await apiService.checkOut({
        'attendance_date': todayDateStr,
        'check_out': nowTimeStr,
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'check_out_address': address,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Absen pulang berhasil"),
            backgroundColor: Colors.green,
          ),
        );
        _loadDashboardData();
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final data = e.response?.data;
        final msg = data?['message'] ?? e.message ?? "Gagal absen pulang";
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

  void _showCheckInDialog() {
    String selectedStatus = "masuk";
    final alasanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Pilih Status Absen", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text("Hadir / Masuk"),
                    value: "masuk",
                    groupValue: selectedStatus,
                    onChanged: (val) {
                      setDialogState(() => selectedStatus = val!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Izin Sakit"),
                    value: "sakit",
                    groupValue: selectedStatus,
                    onChanged: (val) {
                      setDialogState(() => selectedStatus = val!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Izin Keperluan Lain"),
                    value: "izin",
                    groupValue: selectedStatus,
                    onChanged: (val) {
                      setDialogState(() => selectedStatus = val!);
                    },
                  ),
                  if (selectedStatus == "izin") ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: alasanCtrl,
                      decoration: InputDecoration(
                        labelText: "Alasan Izin",
                        hintText: "Masukkan alasan izin...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (selectedStatus == "masuk") {
                      _performCheckIn("masuk", null);
                    } else if (selectedStatus == "sakit") {
                      _performCheckIn("izin", "Sakit");
                    } else {
                      if (alasanCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Alasan izin tidak boleh kosong")),
                        );
                        return;
                      }
                      _performCheckIn("izin", alasanCtrl.text.trim());
                    }
                  },
                  child: const Text("Kirim Absen"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 19) return "Selamat Sore";
    return "Selamat Malam";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
                const Icon(Icons.wifi_off_outlined, size: 54, color: Colors.red),
                const SizedBox(height: 16),
                Text("Terjadi Kesalahan:\n$_errorMsg", textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadDashboardData,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final displayDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    final hasCheckedIn = _todayAttendance != null;
    final hasCheckedOut = _todayAttendance?.checkOutTime != null;
    final isTodayIzin = _todayAttendance?.status?.toLowerCase() == "izin" ||
                        _todayAttendance?.status?.toLowerCase() == "sakit" ||
                        (_todayAttendance?.alasanIzin != null && _todayAttendance!.alasanIzin!.trim().isNotEmpty);
    final isTodaySakit = _todayAttendance?.alasanIzin?.toLowerCase() == "sakit" ||
                         _todayAttendance?.status?.toLowerCase() == "sakit";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Absensi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                        ? [Colors.blue.shade900, Colors.blue.shade800]
                        : [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.name ?? 'Pengguna',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(displayDate, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Section
              const Text(
                "Statistik Kehadiran Anda",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.blue.shade800, size: 28),
                          const SizedBox(height: 8),
                          const Text("Masuk", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            "${_stats?.totalMasuk ?? 0}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade800, size: 28),
                          const SizedBox(height: 8),
                          const Text("Izin", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            "${_stats?.totalIzin ?? 0}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Google Map showing current location of user
              const Text(
                "Lokasi Anda Saat Ini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: _currentPosition == null
                    ? Container(
                        color: Colors.blue.shade50,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text("Sedang memuat lokasi GPS...", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _useSimulatedLocation
                              ? const LatLng(ppkdLatitude, ppkdLongitude)
                              : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                          zoom: 16.5,
                        ),
                        onMapCreated: (controller) => _mapController = controller,
                        markers: _getMarkers(),
                        circles: _getCircles(),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
              ),
              const SizedBox(height: 12),
              // Geofence Info & Simulation Control Card
              if (_currentPosition != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.blue.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _useSimulatedLocation
                          ? Colors.blue.shade300
                          : (_distanceToPPKD != null && _distanceToPPKD! <= 100)
                              ? Colors.green.shade300
                              : Colors.orange.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            _useSimulatedLocation
                                ? Icons.gps_fixed_outlined
                                : (_distanceToPPKD != null && _distanceToPPKD! <= 100)
                                    ? Icons.verified
                                    : Icons.warning_amber_rounded,
                            color: _useSimulatedLocation
                                ? Colors.blue.shade800
                                : (_distanceToPPKD != null && _distanceToPPKD! <= 100)
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _useSimulatedLocation
                                      ? "Simulasi Lokasi PPKD Aktif"
                                      : (_distanceToPPKD != null && _distanceToPPKD! <= 100)
                                          ? "Anda Berada di Area PPKD"
                                          : "Di Luar Area PPKD Jakarta Pusat",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _useSimulatedLocation
                                        ? Colors.blue.shade900
                                        : (_distanceToPPKD != null && _distanceToPPKD! <= 100)
                                            ? Colors.green.shade900
                                            : Colors.orange.shade900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _useSimulatedLocation
                                      ? "Menggunakan titik koordinat PPKD Jakarta Pusat."
                                      : "Jarak ke PPKD: ${_distanceToPPKD != null ? (_distanceToPPKD! > 1000 ? '${(_distanceToPPKD! / 1000).toStringAsFixed(2)} km' : '${_distanceToPPKD!.toStringAsFixed(1)} m') : 'Menghitung...'} (Maks 100 m)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey.shade400 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Simulasikan Lokasi PPKD (Uji Coba)",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          Switch(
                            value: _useSimulatedLocation,
                            activeColor: Colors.blue.shade700,
                            onChanged: (value) {
                              setState(() {
                                _useSimulatedLocation = value;
                              });
                              if (_mapController != null) {
                                final targetLat = value ? ppkdLatitude : _currentPosition!.latitude;
                                final targetLng = value ? ppkdLongitude : _currentPosition!.longitude;
                                _mapController!.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(targetLat, targetLng),
                                    16.5,
                                  ),
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value
                                      ? "Simulasi Lokasi PPKD Jakarta Pusat diaktifkan."
                                      : "Menggunakan lokasi GPS asli perangkat."),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: value ? Colors.blue : Colors.grey.shade800,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),

              // Today's Attendance Cards
              const Text(
                "Kehadiran Hari Ini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              isTodayIzin
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isTodaySakit 
                              ? [Colors.red.shade50, Colors.white]
                              : [Colors.orange.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isTodaySakit ? Colors.red.shade100 : Colors.orange.shade100,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isTodaySakit ? Icons.local_hospital : Icons.info,
                            color: isTodaySakit ? Colors.red.shade800 : Colors.orange.shade800,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isTodaySakit ? "Izin Sakit Hari Ini" : "Izin Hari Ini",
                                      style: TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold,
                                        color: isTodaySakit ? Colors.red.shade900 : Colors.orange.shade900,
                                      ),
                                    ),
                                    Text(
                                      displayDate,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Divider(),
                                const SizedBox(height: 6),
                                const Text(
                                  "Alasan:",
                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _todayAttendance?.alasanIzin ?? '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isTodaySakit ? Colors.red.shade900 : Colors.orange.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Absen Masuk:", style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(
                                hasCheckedIn ? (_todayAttendance?.checkInTime ?? '-') : 'Belum Absen',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasCheckedIn ? Colors.green.shade700 : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Absen Pulang:", style: TextStyle(fontWeight: FontWeight.w500)),
                              Text(
                                hasCheckedOut ? (_todayAttendance?.checkOutTime ?? '-') : 'Belum Absen',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasCheckedOut ? Colors.green.shade700 : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text("Absen Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _showCheckInDialog,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text("Absen Pulang", style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _performCheckOut,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
