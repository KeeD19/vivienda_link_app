import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';
import '../models/OrdersModel.dart';

class OrdersProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  // List<Object> _data = [];
  List<Order> _data = [];
  String _successMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  List get data => _data;
  bool get isLoading => _isLoading;

  Future<void> getOrders() async {
    _errorMessage = '';
    _successMessage = '';
    String? idUser = await _saveLocalService.getData("idUser");
    int _idUser = int.tryParse(idUser!) ?? 0;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService
          .getData('OrdenesT/ObtenerOrdenesClientes?IdCliente=$_idUser');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        // print(jsonData);
        try {
          _data = jsonData.map((order) {
            return Order.fromJson(order);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
          print('Error: al mapear los datos');
        }
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
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
  // Future<void> register() async {
  //   _errorMessage = "";
  //   _successMessage = "";
  //   _isLoading = true;
  //   Map<String, dynamic> data = {
  //     'nombre': fullName,
  //     'telefono': phone,
  //     'correo': email,
  //     'password': pass1,
  //   };
  //   notifyListeners(); // Notificar a los widgets que el estado ha cambiado
  //   try {
  //     final response =
  //         await _apiService.postData('Clientes/AgregarCliente', data);
  //     int statusCode = response['statusCode'];
  //     if (statusCode == 200) {
  //       print("Success");
  //       _successMessage =
  //           "Usuario creado correctamente, ya puedes iniciar sesión";
  //       notifyListeners();
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //     notifyListeners();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
