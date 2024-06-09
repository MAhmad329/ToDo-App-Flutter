import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../core/constants/constants.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool isLoading = false;
  String? errorMessage;
  bool isPasswordVisible = false;
  User? get user => _user;

  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User.fromJson(data);
        errorMessage = null;
      } else {
        errorMessage = 'Failed to login';
      }
    } catch (e) {
      errorMessage = 'An error occurred during login: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> fetchUserDetails() async {
    if (_user == null) return;

    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {'Authorization': 'Bearer ${_user!.token}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User.fromJson(data);
        errorMessage = null;
      } else {
        errorMessage = 'Failed to fetch user details';
      }
    } catch (e) {
      errorMessage = 'An error occurred while fetching user details: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> refreshToken() async {
    if (_user == null) return;

    isLoading = true;
    easyLoading();
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': _user!.refreshToken,
          'expiresInMins': 30,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User(
          id: _user!.id,
          username: _user!.username,
          email: _user!.email,
          firstName: _user!.firstName,
          lastName: _user!.lastName,
          gender: _user!.gender,
          image: _user!.image,
          token: data['token'],
          refreshToken: data['refreshToken'],
        );
        errorMessage = null;
      } else {
        errorMessage = 'Failed to refresh token';
      }
    } catch (e) {
      errorMessage = 'An error occurred while refreshing token: $e';
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
