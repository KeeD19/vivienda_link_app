import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vivienda_link_app/models/ListChatModel.dart';
import '../models/Client_Model.dart';
import '../models/MensajesModel.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';
import '../models/OrdersModel.dart';

class OrdersProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  // List<Object> _data = [];
  List<Order> _data = [];
  List<ListaChatProv> _dataChat = [];
  ClientModel? _dataClient;
  List<Mensajes> _dataChatMessagge = [];
  String _successMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  List get data => _data;
  List get dataChat => _dataChat;
  get dataClient => _dataClient;
  List get dataChatMessagge => _dataChatMessagge;
  bool get isLoading => _isLoading;

  Future<void> getOrders() async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService
          .getData('OrdenesT/ObtenerOrdenesClientes?IdCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> jsonData = jsonResponse['data'];
        // print(jsonData);
        try {
          _data = jsonData.map((order) {
            return Order.fromJson(order);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
          // print('Error: al mapear los datos');
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

  // Método para enviar comentarios
  Future<void> saveComent(int idCliente, int idOrden, String message) async {
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'comentario': message,
      'idUsuario': idCliente,
      'idTrabajo': idOrden,
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.postData('OrdenesT/AgregarComentario', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Comentario enviado";
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
      final response = await _apiService
          .getData('Mensajes/ObtenerListaChatCliente?idCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _dataChat = jsonData.map((listaChatProv) {
            return ListaChatProv.fromJson(listaChatProv);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
        }
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = e.toString();
      print(e.toString());
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getChat(int idProv) async {
    print(idProv);
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getData(
          'Mensajes/ObtenerMensaje?idProveedor=$idProv&idCliente=$idUser0&Identificador=Cliente');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _dataChatMessagge = jsonData.map((mensajes) {
            return Mensajes.fromJson(mensajes);
          }).toList();
        } catch (e) {
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

  Future<void> saveMessage(int idProvedor, String message) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'contenido': message,
      'idProveedor': idProvedor,
      'idCliente': idUser0,
      'status': "Enviado",
      'identificador': "Cliente",
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.postData('Mensajes/AgregarMensaje', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Mensaje enviado";
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

  Future<void> saveResenia(int idProvedor, int rating, String comment) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'descripcion': comment,
      'estrellas': rating,
      'idCliente': idUser0,
      'idProveedor': idProvedor,
      'activo': 0,
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.postData('Resenias/AgregarResenia', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Reseña guardada";
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

  Future<void> saveReporte(int idProvedor, String motivoReporte) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'motivoReporte': motivoReporte,
      'idCliente': idUser0,
      'idProveedor': idProvedor
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.postData('ReporteProveedor/AgregarReporte', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Reporte enviado";
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

  Future<void> getDataPerfil() async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService
          .getData('Clientes/ObtenerCliente?idCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final jsonData = jsonResponse['data'];
        _dataClient = ClientModel.fromJson(jsonData);
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

  Future<void> updateClient(String name, String phone, String email) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'idCliente': idUser0,
      'nombre': name,
      'telefono': phone,
      'correo': email
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.updateData('Clientes/EditarCliente', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Los datos han sido actualizados";
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

  Future<void> updatePass(String newPass, String oldPass) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'IdCliente': idUser0,
      'OldPassword': oldPass,
      'NewPassword': newPass
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response =
          await _apiService.updateData('Clientes/CambiarContrasenia', data);
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
}
