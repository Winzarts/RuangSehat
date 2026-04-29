import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ruang_sehat/features/auth/data/userModel.dart';
import 'dart:convert';

class AuthServices {
  
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String authBaseUrl = '$baseUrl/auth';

  static Future<http.Response> register(
    String name,
    String username,
    String password,
  ) async {
    final url = Uri.parse('$authBaseUrl/register');

    return await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: json.encode({
        "name": name,
        "username": username,
        "password": password,
        "appSource": "kesehatan",
      }),
    );
  }

  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$authBaseUrl/login');

    return await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
        "appSource": "kesehatan",
      }),
    );
  }

  static Future<http.Response> Logout() async {
    final url = Uri.parse('$authBaseUrl/logout');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  static Future<UserModel> getProfile() async {
    final url = Uri.parse('$authBaseUrl/profile');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil profile user');
    }
  }
}