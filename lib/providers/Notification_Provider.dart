import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/NotificacionesModel.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  String _successMessage = '';
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _totalNotificaciones = 0;
  int get totalNotificaciones => _totalNotificaciones;
  List<NotificacionesModel> _notificaciones = [];
  List get dataNotificaciones => _notificaciones;

  Future<void> getNotificaciones() async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getData('Notificaciones/ObtenerNotificaciones?idUsuario=$idUser0&identificador=Cliente');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        final totalData = jsonResponse['total'];
        _totalNotificaciones = totalData;
        try {
          _notificaciones = jsonData.map((notificacion) {
            return NotificacionesModel.fromJson(notificacion);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
        }
      } else {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotificacion(int idNotificacion) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = "";
    _successMessage = "";
    try {
      final response = await _apiService.updateD('Notificaciones/EditarVistaNotificacion?idNotificacion=$idNotificacion');
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
}
