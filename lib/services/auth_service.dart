import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool _isAdminLoggedIn = false;

  bool get isAdminLoggedIn => _isAdminLoggedIn;

  void loginAdmin(String password) {
    // Simplesmente verifica uma senha fixa por enquanto
    if (password == 'admin') {
      _isAdminLoggedIn = true;
      notifyListeners();
    }
  }

  void logoutAdmin() {
    _isAdminLoggedIn = false;
    notifyListeners();
  }
}
