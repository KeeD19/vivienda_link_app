import 'package:flutter/material.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  String _successMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool get isLoading => _isLoading;
  // login
  String? username;
  String? password;
  bool _isAuthenticated = false;
  // register
  String? fullName;
  String? phone;
  String? email;
  String? pass1;
  String? pass2;

  bool get isAuthenticated => _isAuthenticated;

  // Método para autenticar
  Future<void> login() async {
    _errorMessage = '';
    _successMessage = '';
    Map<String, dynamic> data = {
      'user': username,
      'password': password,
    };
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.postData('v1/Auth/LoginClient', data);

      String token = response['token'];
      String user = response['user'];
      String idUser = response['idUser'];

      if (token != "") {
        await _saveLocalService.saveData("auth_token", token);
        await _saveLocalService.saveData("user", user);
        await _saveLocalService.saveData("idUser", idUser);
        await _saveLocalService.saveData("sesion", "true");
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para registrar
  Future<void> register() async {
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'nombre': fullName,
      'telefono': phone,
      'correo': email,
      'password': pass1,
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.postData('Clientes/AgregarCliente', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        print("Success");
        _successMessage =
            "Usuario creado correctamente, ya puedes iniciar sesión";
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // cerrar sesion
  void logout() async {
    await _saveLocalService.clearData("idUser");
    await _saveLocalService.clearData("idauth_token");
    await _saveLocalService.clearData("user");
    _isAuthenticated = false;
    notifyListeners();
  }
}
