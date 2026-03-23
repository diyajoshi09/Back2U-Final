import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> removeToken() async {
    await _prefs.remove('token');
  }

  // User data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString('user', jsonEncode(user));
  }

  static Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString('user');
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  static Future<void> removeUser() async {
    await _prefs.remove('user');
  }

  // Admin flag
  static Future<void> saveIsAdmin(bool isAdmin) async {
    await _prefs.setBool('isAdmin', isAdmin);
  }

  static bool getIsAdmin() {
    return _prefs.getBool('isAdmin') ?? false;
  }

  // Clear all
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
