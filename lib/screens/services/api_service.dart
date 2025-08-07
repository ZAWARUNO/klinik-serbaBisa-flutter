import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/doctor_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.233:8000/api/v1'; // Ganti dengan URL Laravel Anda
  
  static Future<List<Doctor>> getDoctorSchedules() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dokter-schedule'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          final List<dynamic> doctorsJson = data['data'];
          return doctorsJson.map((json) => Doctor.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load doctors: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load doctors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }
}