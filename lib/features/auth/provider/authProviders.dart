import 'dart:convert';
import 'package:Ruang_sehat/features/auth/data/userModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ruang_sehat/features/auth/data/authServices.dart';

class Authproviders extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserModel? get profile => _profile;

  Future<bool> register(String name, String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();

    try {
      final response = await AuthServices.register(name, username, password);
      final body = jsonDecode(response.body);

      if (body['success'] == true) {
        _successMessage = body['message'] ?? 'Register Berhasil';
        return true;
      } else {
        if (body['errors'] != null && body['errors'].length > 0) {
          final firstError = body['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = body['message'] ?? 'Terjadi Kesalahan';
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi Kesalahan Koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();

    try {
      final response = await AuthServices.login(username, password);
      final body = jsonDecode(response.body);

      if (body['success'] == true) {
        final token = body['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        _successMessage = body['message'] ?? 'Login Berhasil';
        return true;
      } else {
        if (body['errors'] != null && body['errors'].length > 0) {
          final firstError = body['errors'][0];
          _errorMessage = firstError['message'];
        } else {
          _errorMessage = body['message'] ?? 'Terjadi Kesalahan';
        }
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi Kesalahan Koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return;
    }

    final response = await AuthServices.Logout();
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await prefs.remove('token');
      _successMessage = data['message'] ?? 'Anda berhasil keluar';
    } else {
      _errorMessage = data['message'] ?? 'Terjadi Kesalahan';
    }

    notifyListeners();
  }

  Future<void> getProfile() async {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return;
    }

    try {
      final result = await AuthServices.getProfile();
      _profile = result;
      _successMessage = "Profile berhasil diambil";
    } catch (e) {
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<bool> updateProfile(
    String name,
    String username,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return false;
    }

    try {
      final result = await AuthServices.updateProfile(name, username, password);
      final body = jsonDecode(result.body);

      if (result.statusCode == 200) {
        _successMessage = body['message'] ?? 'Profile berhasil diupdate';
        await getProfile();
        return true;
      } else {
        _errorMessage = body['message'] ?? 'Terjadi Kesalahan';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
