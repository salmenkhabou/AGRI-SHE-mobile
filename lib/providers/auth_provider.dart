import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userRole;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  String? get userId => _userId;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - in real app, validate with backend
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      
      // Determine role based on email for demo
      if (email.contains('farmer')) {
        _userRole = 'farmer';
      } else if (email.contains('ngo')) {
        _userRole = 'ngo';
      } else {
        _userRole = 'buyer';
      }
      
      _userId = email.split('@')[0];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup(Map<String, dynamic> userData) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userRole = userData['role'] ?? 'farmer';
    _userId = userData['email']?.split('@')[0];
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = null;
    _userId = null;
    notifyListeners();
  }
}
