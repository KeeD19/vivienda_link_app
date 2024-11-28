import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vivienda_link_app/models/OrdersModel.dart';
import '../models/ListChatModel.dart';
import '../models/Proveedor_Model.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';

class ProvedorProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();

  String _errorMessage = '';
  String _successMessage = '';
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Order> _data = [];
  List<Order> get orderData => _data;
  Order? _dataorden;
  get dataorden => _dataorden;
  ProvedorModel? _dataClient;
  get dataClient => _dataClient;
  List<ListaChatProv> _dataChat = [];
  List get dataChat => _dataChat;

  Future<void> getOrders() async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('OrdenesT/ObtenerOrdenes?IdProveedor=$idUser0&pageNumber=01&pageSize=01');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _data = jsonData.map((order) {
            return Order.fromJson(order);
          }).toList();
        } catch (e) {
          debugPrint("Error al mapear los datos: $e");
          _errorMessage = 'Error: al mapear los datos';
        }
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrder(int idOrden) async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('OrdenesT/ObtenerOrdenProvedor?IdProveedor=$idUser0&IdOrden=$idOrden');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final jsonData = jsonResponse['data'];
        _dataorden = Order.fromJson(jsonData);
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

  Future<void> updateOrder(String status, String photo, int idOrden) async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    Map<String, dynamic> data = {"idOrdenTrabajo": idOrden, "estado": status, "idProveedor": idUser0, "archivo": photo, "extencionArchivo": "jpg"};
    try {
      final response = await _apiService.updateData('OrdenesT/EditarOrden', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "La orden ha sido actualizado";
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

  Future<void> getDataPerfil() async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('Provedores/ObtenerProvedor?id=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final jsonData = jsonResponse['data'];
        _dataClient = ProvedorModel.fromJson(jsonData);
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProvedor(String name, String nameCompany, String phone, String email, String? selfie) async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    Map<String, dynamic> data = {'idProvedor': idUser0, 'nombre': name, 'nombreEmpresarial': nameCompany, 'telefono': phone, 'correo': email, 'Selfie': selfie};
    try {
      final response = await _apiService.updateData('Provedores/EditarProvedores', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Los datos han sido actualizados";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePass(String newPass, String oldPass) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {'idProvedor': idUser0, 'oldPassword': oldPass, 'newPassword': newPass};
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response = await _apiService.updateData('Provedores/CambiarContraseña', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "La contraseña ha sido actualizada";
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

  Future<void> getListchatProv() async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getData('Mensajes/ObtenerListaChat?idProveedor=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _dataChat = jsonData.map((listaChatProv) {
            return ListaChatProv.fromJson(listaChatProv);
          }).toList();
        } catch (e) {
          debugPrint('Error: al mapear los datos');
          _errorMessage = 'Error: al mapear los datos';
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

  Future<void> updateSolicitud(int idSolicitud, int status) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = "";
    _successMessage = "";
    try {
      final response = await _apiService.updateD('SolicitudServicio/EstatusSolicitud?idSolicitud=$idSolicitud&status=$status');
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Se actualizo la solicitud";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
