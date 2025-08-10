import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserService {
  static const String _userKey = 'user_data';
  static const String _emailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user data after successful login/register
  static Future<void> saveUserData(UserData user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save user object
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      // Save email separately for easy access
      await prefs.setString(_emailKey, user.email);

      // Mark as logged in
      await prefs.setBool(_isLoggedInKey, true);

      print('✅ User data saved: ${user.email}');
    } catch (e) {
      print('❌ Error saving user data: $e');
    }
  }

  // Get current user data
  static Future<UserData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userMap = jsonDecode(userJson);
        return UserData.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Get current user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('❌ Error getting user email: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Clear user data on logout
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_emailKey);
      await prefs.setBool(_isLoggedInKey, false);

      print('✅ User data cleared');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }
}
