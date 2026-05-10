import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      _user = UserModel(
        id: prefs.getString('userId') ?? 'u001',
        name: prefs.getString('userName') ?? 'Analyst',
        email: prefs.getString('userEmail') ?? 'analyst@datamind.ai',
        role: prefs.getString('userRole') ?? 'Data Scientist',
        avatarUrl: null,
        joinDate: DateTime.now().subtract(const Duration(days: 120)),
      );
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    // Demo credentials check
    if (email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: 'u001',
        name: _getNameFromEmail(email),
        email: email,
        role: 'Data Scientist',
        avatarUrl: null,
        joinDate: DateTime.now(),
      );
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userRole', _user!.role);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid credentials. Please check your email and password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: role,
        avatarUrl: null,
        joinDate: DateTime.now(),
      );
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', _user!.id);
      await prefs.setString('userName', _user!.name);
      await prefs.setString('userEmail', _user!.email);
      await prefs.setString('userRole', _user!.role);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Please fill all fields correctly.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  String _getNameFromEmail(String email) {
    final name = email.split('@').first;
    return name.split('.').map((s) => s.isNotEmpty
        ? s[0].toUpperCase() + s.substring(1)
        : '').join(' ');
  }
}
