import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifound/config/app_config.dart';
import '../models/item_model.dart';
import '../models/auth_model.dart';
import 'dart:io';


class ApiService {
  // Update this with your actual API URL

  // Auth endpoints
  static Future<Map<String, dynamic>> register({
    required String universityId,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'university_id': universityId,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> login({
    required String universityId,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'university_id': universityId,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminLogin({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  // Items endpoints
  static Future<List<UniversityItem>> getItems({
    String? type,
    String? categoryId,
    String? claimed,
  }) async {
    var uri = Uri.parse('${AppConfig.baseUrl}/items');

    Map<String, String> queryParams = {};
    if (type != null) queryParams['type'] = type;
    if (categoryId != null) queryParams['category'] = categoryId;
    if (claimed != null) queryParams['claimed'] = claimed;

    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri);
    final data = _handleResponse(response);

    if (data['success'] == true && data['items'] != null) {
      return (data['items'] as List)
          .map((item) => UniversityItem.fromJson(item))
          .toList();
    }
    return [];
  }

  static Future<UniversityItem> getItemById(String id) async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/items/$id'));
    final data = _handleResponse(response);

    if (data['success'] == true && data['item'] != null) {
      return UniversityItem.fromJson(data['item']);
    }
    throw Exception('Item not found');
  }

  static Future<Map<String, dynamic>> createItem({
    required String token,
    required String categoryId,
    required String itemType,
    required String itemName,
    String? description,
    required String location,
    required String dateLostFound,
    List<Map<String, dynamic>>? images,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'category_id': categoryId,
        'item_type': itemType,
        'item_name': itemName,
        'description': description,
        'location': location,
        'date_lost_found': dateLostFound,
        'images': images ?? [],
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateItem({
    required String token,
    required String itemId,
    required Map<String, dynamic> data,
  }) async {
    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/items/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  static Future<void> deleteItem({
    required String token,
    required String itemId,
  }) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/items/$itemId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    _handleResponse(response);
  }

  // User endpoints
  static Future<List<UniversityItem>> getUserItems({
    required String token,
    String? type,
    String? claimed,
  }) async {
    var uri = Uri.parse('${AppConfig.baseUrl}/users/items');

    Map<String, String> queryParams = {};
    if (type != null) queryParams['type'] = type;
    if (claimed != null) queryParams['claimed'] = claimed;

    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = _handleResponse(response);

    if (data['success'] == true && data['items'] != null) {
      return (data['items'] as List)
          .map((item) => UniversityItem.fromJson(item))
          .toList();
    }
    return [];
  }

  static Future<AuthUser> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = _handleResponse(response);

    if (data['success'] == true && data['user'] != null) {
      return AuthUser.fromJson(data['user']);
    }
    throw Exception('Failed to get profile');
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImageUrl,
  }) async {
    Map<String, dynamic> body = {};
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (phone != null) body['phone'] = phone;
    if (profileImageUrl != null) body['profile_image_url'] = profileImageUrl;

    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // Categories endpoint
  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/categories'));
    final data = _handleResponse(response);

    if (data['success'] == true && data['categories'] != null) {
      return (data['categories'] as List)
          .map((cat) => Category.fromJson(cat))
          .toList();
    }
    return [];
  }

  // Admin endpoints
  static Future<AdminStats> getAdminStats(String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/admin/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = _handleResponse(response);

    if (data['success'] == true && data['stats'] != null) {
      return AdminStats.fromJson(data['stats']);
    }
    throw Exception('Failed to get stats');
  }

  // Helper method
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Request failed');
    }
  }

  static Future<Map<String, dynamic>> uploadImage({
    required String token,
    required File imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/upload'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add the image file
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );

      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
