import 'package:flutter/material.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  String _successMessage = '';
  int _userValidate = 0;
  int _typeUser = 0;
  int get typeUser => _typeUser;
  String _tokenFirebase = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  int get userValidate => _userValidate;
  String get tokenFirebase => _tokenFirebase;
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
      String tokenFirebase = response['tokenFirebase'] ?? "";
      String user = response['user'];
      String idUser = response['idUser'];
      String tipo = response['tipo'];
      // _typeUser = int.tryParse(idUser)!;

      if (token != "") {
        if (tokenFirebase == "") {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String? firebaseToken = await messaging.getToken();
          Map<String, dynamic> dataChange = {'id': int.tryParse(idUser), 'tokenFirebase': firebaseToken, "identificador": "Cliente"};
          final tokenUpdate = await _apiService.postData('v1/Auth/SaveToken', dataChange);
          int statusCode = tokenUpdate['statusCode'];
          if (statusCode == 200) {
            await _saveLocalService.saveData("tokenFirebase", firebaseToken!);
          }
        }
        String? tokenLocal = await _saveLocalService.getData("tokenFirebase");

        if (tokenLocal == null || tokenLocal == "") {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String? firebaseToken = await messaging.getToken();
          Map<String, dynamic> dataChange = {'id': int.tryParse(idUser), 'tokenFirebase': firebaseToken, "identificador": "Cliente"};
          final tokenUpdate = await _apiService.postData('v1/Auth/SaveToken', dataChange);
          int statusCode = tokenUpdate['statusCode'];
          if (statusCode == 200) {
            await _saveLocalService.saveData("tokenFirebase", firebaseToken!);
          }
        }

        await _saveLocalService.saveData("auth_token", token);
        await _saveLocalService.saveData("user", user);
        await _saveLocalService.saveData("idUser", idUser);
        await _saveLocalService.saveData("tipoUser", tipo);
        _userValidate = int.tryParse(idUser) ?? 0;
        notifyListeners();
      } else {
        _isAuthenticated = false;
      }
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
      final response = await _apiService.postData('Clientes/AgregarCliente', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        print("Success");
        _successMessage = "Usuario creado correctamente, ya puedes iniciar sesión";
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
    await _saveLocalService.clearData("auth_token");
    await _saveLocalService.clearData("user");
    await _saveLocalService.clearData("tokenFirebase");
    await _saveLocalService.clearData("tipoUser");

    _isAuthenticated = false;
    _userValidate = 0;
    _successMessage = "Cerrado";

    notifyListeners();
  }

  Future<void> verifySesion() async {
    String? idUser = await _saveLocalService.getData("idUser");
    _userValidate = int.tryParse(idUser!) ?? 0;
    notifyListeners();
  }

  Future<void> getTypeUser() async {
    _isLoading = true;
    notifyListeners();
    String? tipoUser = await _saveLocalService.getData("tipoUser");
    String? idUser = await _saveLocalService.getData("idUser");
    debugPrint('idUser: $idUser');
    _typeUser = int.tryParse(tipoUser!) ?? 0;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyTokenFirebase() async {
    String? TokenFirebase = await _saveLocalService.getData("tokenFirebase");
    _tokenFirebase = TokenFirebase!;
  }

  Future<void> saveTokenFirebase(token) async {
    await _saveLocalService.saveData("tokenFirebase", token);
    _tokenFirebase = token!;
  }
}
