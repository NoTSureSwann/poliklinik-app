import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cqrs/command/auth_command.dart';
import '../api/api_result.dart';

class AuthProvider extends ChangeNotifier {
  final AuthCommandHandler _authCommand;
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _token;
  String? _role;
  String? _username;
  String? _error;

  AuthProvider(this._authCommand) {
    _loadSession();
  }

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get role => _role;
  String? get username => _username;
  String? get error => _error;
  
  // Stubs for UI compilation
  dynamic get currentUser => {'role': _role, 'name': _username};
  Future<void> updateProfile(dynamic user) async {}

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _role = prefs.getString('auth_role');
    _username = prefs.getString('auth_username');
    
    if (_token != null && _token!.isNotEmpty) {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password, {bool rememberMe = false}) async {
    _isLoading = true;
    _error = null;
    // Since mockAPI doesn't have a real POST /login, we might get an error 404.
    final result = await _authCommand.login(username, password);

    bool success = false;
    if (result is ApiSuccess) {
      success = true;
      _role = (result as ApiSuccess<Map<String, dynamic>>).data['role'] ?? 'admin'; 
    } else {
      // Fallback to Firebase Auth if MockAPI fails
      try {
        // Firebase expects an email. If the user typed a plain username, we convert it to a dummy email format.
        String email = username.contains('@') ? username : '$username@klinik.com';
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password,
        );
        success = true;
        // Determine role based on username or mock logic
        _role = username.toLowerCase().contains('admin') ? 'admin' : (username.toLowerCase().contains('dokter') ? 'dokter' : 'pasien');
      } on FirebaseAuthException catch (e) {
        success = false;
        _error = "Firebase Auth failed: ${e.message}";
      } catch (e) {
        success = false;
        _error = "Login failed both in MockAPI and Firebase.";
      }
    }

    if (success) {
      _isAuthenticated = true;
      _token = 'dummy-token-${DateTime.now().millisecondsSinceEpoch}';
      _username = username;

      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('auth_role', _role!);
        await prefs.setString('auth_username', _username!);
      }
    } else if (result is ApiFailure && _error == null) {
      _error = (result as ApiFailure).message;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authCommand.register(data);
    bool success = false;
    
    if (result is ApiSuccess) {
      success = true;
    } else {
      // Fallback to Firebase Auth registration
      try {
        String inputUsername = data['name'] ?? data['email'] ?? 'user';
        // Convert to dummy email if not an email format
        String email = inputUsername.contains('@') ? inputUsername : '$inputUsername@klinik.com';
        String password = data['password'] ?? '123456';
        
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );
        success = true;
      } on FirebaseAuthException catch (e) {
        success = false;
        _error = "Firebase Register failed: ${e.message}";
      } catch (e) {
        success = false;
        _error = "Register failed both in MockAPI and Firebase.";
      }
    }

    if (success) {
      _role = data['role'] ?? 'pasien';
      _username = data['name'] ?? data['email'] ?? 'User';
      _isAuthenticated = true;
      _token = 'dummy-token-${DateTime.now().millisecondsSinceEpoch}';
      
      // Save to SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('auth_role', _role!);
      await prefs.setString('auth_username', _username!);
    } else if (result is ApiFailure && _error == null) {
      _error = (result as ApiFailure).message;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _role = null;
    _username = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_role');
    await prefs.remove('auth_username');
    
    notifyListeners();
  }
}
