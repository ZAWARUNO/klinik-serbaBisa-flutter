import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // PENTING: Ganti dengan URL yang sesuai

  static const String baseUrl = 'http://192.168.18.233:8000/api';
  

  // Tambahkan timeout untuk debugging
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Test connection dengan debugging yang lebih detail
  static Future<bool> testConnection() async {
    try {
      print('🔍 Testing connection to: $baseUrl/test');

      final response = await http
          .get(Uri.parse('$baseUrl/test'), headers: headers)
          .timeout(timeoutDuration);

      print('📡 Response Status Code: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Connection successful!');
        return true;
      } else {
        print('❌ Connection failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 Connection error: $e');
      print('🔍 Error type: ${e.runtimeType}');
      return false;
    }
  }

  // Register dengan debugging
  static Future<AuthResult> register({
    required String email,
    required String nama,
    required int umur,
    required String kelamin,
    required String nomorHp,
    required String alamat,
    required String password,
  }) async {
    try {
      print('🚀 Starting registration process...');
      print('📍 URL: $baseUrl/auth/register');

      final requestBody = {
        'email': email,
        'nama': nama,
        'umur': umur,
        'kelamin': kelamin,
        'nomor_hp': nomorHp,
        'alamat': alamat,
        'password': password,
      };

      print('📝 Request Body: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      print('📡 Registration Response Status: ${response.statusCode}');
      print('📡 Registration Response Body: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        print('✅ Registration successful!');
        return AuthResult(
          success: true,
          message: responseData['message'],
          user: UserData.fromJson(responseData['data']),
        );
      } else {
        String errorMessage = responseData['message'] ?? 'Registrasi gagal';

        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          }
        }

        print('❌ Registration failed: $errorMessage');
        return AuthResult(success: false, message: errorMessage);
      }
    } catch (e) {
      print('💥 Registration error: $e');
      print('🔍 Error type: ${e.runtimeType}');

      String errorMessage = 'Koneksi gagal. ';

      if (e.toString().contains('SocketException')) {
        errorMessage +=
            'Tidak dapat terhubung ke server. Periksa URL dan pastikan server berjalan.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage +=
            'Koneksi timeout. Server mungkin lambat atau tidak merespons.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Response server tidak valid.';
      } else {
        errorMessage += 'Error tidak dikenal: ${e.toString()}';
      }

      return AuthResult(
        success: false,
        message: errorMessage,
        error: e.toString(),
      );
    }
  }

  // Login dengan debugging
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🚀 Starting login process...');
      print('📍 URL: $baseUrl/auth/login');

      final requestBody = {'email': email, 'password': password};

      print('📝 Request Body: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      print('📡 Login Response Status: ${response.statusCode}');
      print('📡 Login Response Body: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('✅ Login successful!');
        return AuthResult(
          success: true,
          message: responseData['message'],
          user: UserData.fromJson(responseData['data']),
        );
      } else {
        print('❌ Login failed: ${responseData['message']}');
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Login gagal',
        );
      }
    } catch (e) {
      print('💥 Login error: $e');
      print('🔍 Error type: ${e.runtimeType}');

      String errorMessage = 'Koneksi gagal. ';

      if (e.toString().contains('SocketException')) {
        errorMessage +=
            'Tidak dapat terhubung ke server. Periksa URL dan pastikan server berjalan.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage +=
            'Koneksi timeout. Server mungkin lambat atau tidak merespons.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Response server tidak valid.';
      } else {
        errorMessage += 'Error tidak dikenal: ${e.toString()}';
      }

      return AuthResult(
        success: false,
        message: errorMessage,
        error: e.toString(),
      );
    }
  }

  // Get user profile dengan debugging
  static Future<AuthResult> getProfile(int userId) async {
    try {
      print('🚀 Getting user profile...');
      print('📍 URL: $baseUrl/auth/profile/$userId');

      final response = await http
          .get(Uri.parse('$baseUrl/auth/profile/$userId'), headers: headers)
          .timeout(timeoutDuration);

      print('📡 Profile Response Status: ${response.statusCode}');
      print('📡 Profile Response Body: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('✅ Profile retrieved successfully!');
        return AuthResult(
          success: true,
          message: responseData['message'],
          user: UserData.fromJson(responseData['data']),
        );
      } else {
        print('❌ Profile retrieval failed: ${responseData['message']}');
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Gagal mengambil data user',
        );
      }
    } catch (e) {
      print('💥 Profile error: $e');
      return AuthResult(
        success: false,
        message: 'Koneksi gagal saat mengambil profil: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Update profile dengan debugging
  static Future<AuthResult> updateProfile({
    required int userId,
    required String nama,
    required int umur,
    required String
    kelamin, // 'L' atau 'P' atau 'Laki-laki'/'Perempuan' tergantung backend
    required String nomorHp,
    required String alamat,
  }) async {
    try {
      print('🚀 Updating profile...');
      print('📍 URL: $baseUrl/auth/profile/$userId');

      final requestBody = {
        'nama': nama,
        'umur': umur,
        'kelamin': kelamin,
        'nomor_hp': nomorHp,
        'alamat': alamat,
      };

      print('📝 Update Body: ${jsonEncode(requestBody)}');

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/profile/$userId'),
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      print('📡 Update Response Status: ${response.statusCode}');
      print('📡 Update Response Body: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return AuthResult(
          success: true,
          message: responseData['message'] ?? 'Profil berhasil diperbarui',
          user: responseData['data'] != null
              ? UserData.fromJson(responseData['data'])
              : null,
        );
      }

      String errorMessage =
          responseData['message'] ?? 'Gagal memperbarui profil';
      if (response.statusCode == 422 && responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          errorMessage = firstError.first;
        }
      }

      return AuthResult(
        success: false,
        message: errorMessage,
        error: response.body,
      );
    } catch (e) {
      print('💥 Update profile error: $e');
      return AuthResult(
        success: false,
        message: 'Koneksi gagal saat update profil: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Method untuk testing berbagai URL
  static Future<void> testMultipleUrls() async {
    final testUrls = [
      'http://192.168.18.233:8000/api',
      'http://127.0.0.1:8000/api',
      'http://localhost:8000/api',
      'http://192.168.18.233/api', // URL yang Anda gunakan
    ];

    print('🧪 Testing multiple URLs...');

    for (String url in testUrls) {
      try {
        print('\n🔍 Testing: $url/test');

        final response = await http
            .get(Uri.parse('$url/test'), headers: headers)
            .timeout(const Duration(seconds: 5));

        print('✅ $url - Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('📄 Body: ${response.body}');
        }
      } catch (e) {
        print('❌ $url - Error: $e');
      }
    }
  }
}

// Auth Result model (sama seperti sebelumnya)
class AuthResult {
  final bool success;
  final String message;
  final UserData? user;
  final String? error;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.error,
  });
}

// User Data model (sama seperti sebelumnya)
class UserData {
  final int id;
  final String email;
  final String nama;
  final int umur;
  final String kelamin;
  final String nomorHp;
  final String alamat;

  UserData({
    required this.id,
    required this.email,
    required this.nama,
    required this.umur,
    required this.kelamin,
    required this.nomorHp,
    required this.alamat,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      nama: json['nama'],
      umur: json['umur'],
      kelamin: json['kelamin'],
      nomorHp: json['nomor_hp'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nama': nama,
      'umur': umur,
      'kelamin': kelamin,
      'nomor_hp': nomorHp,
      'alamat': alamat,
    };
  }
}
