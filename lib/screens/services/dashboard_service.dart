import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl = 'http://192.168.18.232:8000/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Memastikan Laravel mengembalikan JSON (bukan HTML) untuk error
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Get reservasi data untuk pasien
  static Future<DashboardResult> getReservasiData(String email) async {
    try {
      print('🚀 Getting reservasi data for: $email');
      print('📍 URL: $baseUrl/pasien/reservasi/$email');

      final response = await http
          .get(Uri.parse('$baseUrl/pasien/reservasi/$email'), headers: headers)
          .timeout(timeoutDuration);

      print('📡 Reservasi Response Status: ${response.statusCode}');
      print('📡 Reservasi Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> reservasiList = responseData['data'] ?? [];
          final List<ReservasiData> reservasi = reservasiList
              .map((json) => ReservasiData.fromJson(json))
              .toList();

          return DashboardResult(
            success: true,
            message: responseData['message'] ?? 'Data berhasil diambil',
            reservasiData: reservasi,
          );
        } else {
          return DashboardResult(
            success: false,
            message:
                responseData['message'] ?? 'Gagal mengambil data reservasi',
          );
        }
      } else {
        return DashboardResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('💥 Reservasi error: $e');
      return DashboardResult(
        success: false,
        message: 'Koneksi gagal: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Get jadwal dokter
  static Future<DashboardResult> getJadwalDokter() async {
    try {
      print('🚀 Getting jadwal dokter data');
      print('📍 URL: $baseUrl/jadwal-dokter');

      final response = await http
          .get(Uri.parse('$baseUrl/jadwal-dokter'), headers: headers)
          .timeout(timeoutDuration);

      print('📡 Jadwal Response Status: ${response.statusCode}');
      print('📡 Jadwal Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> jadwalList = responseData['data'] ?? [];
          final List<JadwalData> jadwal = jadwalList
              .map((json) => JadwalData.fromJson(json))
              .toList();

          return DashboardResult(
            success: true,
            message: responseData['message'] ?? 'Data jadwal berhasil diambil',
            jadwalData: jadwal,
          );
        } else {
          return DashboardResult(
            success: false,
            message: responseData['message'] ?? 'Gagal mengambil data jadwal',
          );
        }
      } else {
        return DashboardResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('💥 Jadwal error: $e');
      return DashboardResult(
        success: false,
        message: 'Koneksi gagal: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Get hasil reservasi untuk pasien
  static Future<DashboardResult> getHasilReservasi(String email) async {
    try {
      print('🚀 Getting hasil reservasi for: $email');
      print('📍 URL: $baseUrl/pasien/hasil-reservasi/$email');

      final response = await http
          .get(
            Uri.parse('$baseUrl/pasien/hasil-reservasi/$email'),
            headers: headers,
          )
          .timeout(timeoutDuration);

      print('📡 Hasil Reservasi Response Status: ${response.statusCode}');
      print('📡 Hasil Reservasi Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> hasilList = responseData['data'] ?? [];
          final List<HasilReservasiData> hasil = hasilList
              .map((json) => HasilReservasiData.fromJson(json))
              .toList();

          return DashboardResult(
            success: true,
            message: responseData['message'] ?? 'Data hasil berhasil diambil',
            hasilReservasiData: hasil,
          );
        } else {
          return DashboardResult(
            success: false,
            message: responseData['message'] ?? 'Gagal mengambil data hasil',
          );
        }
      } else {
        return DashboardResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('💥 Hasil reservasi error: $e');
      return DashboardResult(
        success: false,
        message: 'Koneksi gagal: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Get dashboard statistics
  static Future<DashboardResult> getDashboardStats(String email) async {
    try {
      print('🚀 Getting dashboard statistics for: $email');
      print('📍 URL: $baseUrl/pasien/dashboard-stats/$email');

      final response = await http
          .get(
            Uri.parse('$baseUrl/pasien/dashboard-stats/$email'),
            headers: headers,
          )
          .timeout(timeoutDuration);

      print('📡 Stats Response Status: ${response.statusCode}');
      print('📡 Stats Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final Map<String, dynamic> statsData = responseData['data'] ?? {};
          final DashboardStats stats = DashboardStats.fromJson(statsData);

          return DashboardResult(
            success: true,
            message: responseData['message'] ?? 'Statistik berhasil diambil',
            dashboardStats: stats,
          );
        } else {
          return DashboardResult(
            success: false,
            message: responseData['message'] ?? 'Gagal mengambil statistik',
          );
        }
      } else {
        return DashboardResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('💥 Stats error: $e');
      return DashboardResult(
        success: false,
        message: 'Koneksi gagal: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Create appointment
  static Future<DashboardResult> createAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      print('🚀 Creating appointment');
      print('📍 URL: $baseUrl/pasien/create-appointment');
      print('📝 Appointment Data: ${jsonEncode(appointmentData)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/pasien/create-appointment'),
            headers: headers,
            body: jsonEncode(appointmentData),
          )
          .timeout(timeoutDuration);

      print('📡 Create Appointment Response Status: ${response.statusCode}');
      print('📡 Create Appointment Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          return DashboardResult(
            success: true,
            message: responseData['message'] ?? 'Janji temu berhasil dibuat',
          );
        } else {
          return DashboardResult(
            success: false,
            message: responseData['message'] ?? 'Gagal membuat janji temu',
            error: response.body,
          );
        }
      } else if (response.statusCode == 422) {
        // Tampilkan pesan validasi yang jelas dari Laravel
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String message = responseData['message'] ?? 'Validasi gagal';
          if (responseData['errors'] is Map<String, dynamic>) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final firstKey = errors.keys.isNotEmpty ? errors.keys.first : null;
            final firstVal = firstKey != null ? errors[firstKey] : null;
            if (firstVal is List && firstVal.isNotEmpty) {
              message = firstVal.first.toString();
            }
          }
          return DashboardResult(
            success: false,
            message: message,
            error: response.body,
          );
        } catch (_) {
          return DashboardResult(
            success: false,
            message: 'Validasi gagal (422) – cek input Anda',
            error: response.body,
          );
        }
      } else if (response.statusCode == 500) {
        // Tampilkan pesan server error yang lebih informatif jika ada
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final message =
              responseData['message'] ?? 'Terjadi kesalahan pada server (500)';
          return DashboardResult(
            success: false,
            message: message,
            error: response.body,
          );
        } catch (_) {
          return DashboardResult(
            success: false,
            message: 'Terjadi kesalahan pada server (500)',
            error: response.body,
          );
        }
      } else {
        // Coba ambil pesan dari body jika tersedia
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final message =
              responseData['message'] ?? 'Server error: ${response.statusCode}';
          return DashboardResult(
            success: false,
            message: message,
            error: response.body,
          );
        } catch (_) {
          return DashboardResult(
            success: false,
            message: 'Server error: ${response.statusCode}',
            error: response.body,
          );
        }
      }
    } catch (e) {
      print('💥 Create appointment error: $e');
      return DashboardResult(
        success: false,
        message: 'Koneksi gagal: ${e.toString()}',
        error: e.toString(),
      );
    }
  }
}

// Dashboard Result model
class DashboardResult {
  final bool success;
  final String message;
  final List<ReservasiData>? reservasiData;
  final List<JadwalData>? jadwalData;
  final List<HasilReservasiData>? hasilReservasiData;
  final DashboardStats? dashboardStats;
  final String? error;

  DashboardResult({
    required this.success,
    required this.message,
    this.reservasiData,
    this.jadwalData,
    this.hasilReservasiData,
    this.dashboardStats,
    this.error,
  });
}

// Reservasi Data model
class ReservasiData {
  final int id;
  final String email;
  final String nama;
  final int umur;
  final String kelamin;
  final String nomorHp;
  final String alamat;
  final int scheduleId;
  final String keluhan;
  final String status;
  final String? namaDokter;
  final String? poli;
  final String? hari;
  final String? waktu;
  final DateTime createdAt;

  ReservasiData({
    required this.id,
    required this.email,
    required this.nama,
    required this.umur,
    required this.kelamin,
    required this.nomorHp,
    required this.alamat,
    required this.scheduleId,
    required this.keluhan,
    required this.status,
    this.namaDokter,
    this.poli,
    this.hari,
    this.waktu,
    required this.createdAt,
  });

  factory ReservasiData.fromJson(Map<String, dynamic> json) {
    return ReservasiData(
      id: json['id'],
      email: json['email'],
      nama: json['nama'],
      umur: json['umur'],
      kelamin: json['kelamin'],
      nomorHp: json['nomor_hp'],
      alamat: json['alamat'],
      scheduleId: json['schedule_id'],
      keluhan: json['keluhan'],
      status: json['status'] ?? 'belum',
      namaDokter: json['nama_dokter'],
      poli: json['poli'],
      hari: json['hari'],
      waktu: json['waktu'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Jadwal Data model
class JadwalData {
  final int scheduleId;
  final String nama;
  final String poli;
  final String hari;
  final String waktu;
  final int maximalReservasi;

  JadwalData({
    required this.scheduleId,
    required this.nama,
    required this.poli,
    required this.hari,
    required this.waktu,
    required this.maximalReservasi,
  });

  factory JadwalData.fromJson(Map<String, dynamic> json) {
    return JadwalData(
      scheduleId: json['schedule_id'],
      nama: json['nama'],
      poli: json['poli'],
      hari: json['hari'],
      waktu: json['waktu'],
      maximalReservasi: json['maximal_reservasi'],
    );
  }
}

// Hasil Reservasi Data model
class HasilReservasiData {
  final int id;
  final String email;
  final String nama;
  final int umur;
  final String kelamin;
  final String ringkasanAnamnesis;
  final String pemeriksaanFisik;
  final String diagnosis;
  final String obat;
  final String tindakan;
  final String edukasiSaran;
  final DateTime createdAt;

  HasilReservasiData({
    required this.id,
    required this.email,
    required this.nama,
    required this.umur,
    required this.kelamin,
    required this.ringkasanAnamnesis,
    required this.pemeriksaanFisik,
    required this.diagnosis,
    required this.obat,
    required this.tindakan,
    required this.edukasiSaran,
    required this.createdAt,
  });

  factory HasilReservasiData.fromJson(Map<String, dynamic> json) {
    return HasilReservasiData(
      id: json['id'],
      email: json['email'],
      nama: json['nama'],
      umur: json['umur'],
      kelamin: json['kelamin'],
      ringkasanAnamnesis: json['ringkasan_anamnesis'],
      pemeriksaanFisik: json['pemeriksaan_fisik'],
      diagnosis: json['diagnosis'],
      obat: json['obat'],
      tindakan: json['tindakan'],
      edukasiSaran: json['edukasi_saran'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Dashboard Stats model
class DashboardStats {
  final int totalReservasi;
  final int reservasiBelum;
  final int reservasiSudah;
  final int totalHasilReservasi;
  final int jadwalHariIni;

  DashboardStats({
    required this.totalReservasi,
    required this.reservasiBelum,
    required this.reservasiSudah,
    required this.totalHasilReservasi,
    required this.jadwalHariIni,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalReservasi: json['total_reservasi'] ?? 0,
      reservasiBelum: json['reservasi_belum'] ?? 0,
      reservasiSudah: json['reservasi_sudah'] ?? 0,
      totalHasilReservasi: json['total_hasil_reservasi'] ?? 0,
      jadwalHariIni: json['jadwal_hari_ini'] ?? 0,
    );
  }
}
