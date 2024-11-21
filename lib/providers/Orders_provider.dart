import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vivienda_link_app/models/FilterOptionsModel.dart';
import 'package:vivienda_link_app/models/ListChatModel.dart';
import 'package:vivienda_link_app/models/PagosModel.dart';
import 'package:vivienda_link_app/models/PlanModel.dart';
import 'package:vivienda_link_app/models/ServiciosModel.dart';
import 'package:vivienda_link_app/models/ServiciosPopularModel.dart';
import '../models/Client_Model.dart';
import '../models/MensajesModel.dart';
import '../services/Apis.dart';
import '../services/SaveLocalService.dart';
import '../models/OrdersModel.dart';
import 'package:diacritic/diacritic.dart';

class OrdersProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SaveLocalService _saveLocalService = SaveLocalService();
  String _errorMessage = '';
  List<Order> _data = [];
  List<ListaChatProv> _dataChat = [];
  ClientModel? _dataClient;
  List<PlanModel> _dataPlan = [];
  List<ServiciosModel> _dataServicios = [];
  List<Mensajes> _dataChatMessagge = [];
  String _successMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  List get data => _data;
  List get dataChat => _dataChat;
  get dataClient => _dataClient;
  List get dataPlan => _dataPlan;
  List get dataServicios => _dataServicios;
  List get dataChatMessagge => _dataChatMessagge;
  bool get isLoading => _isLoading;
  List<FilterOptionsModel> _serviciosFiltrados = [];
  List get dataServiciosFiltrados => _serviciosFiltrados;
  List<ServiciosPopularModel> _serviciosPopulares = [];
  List get dataServiciosPopulares => _serviciosPopulares;
  Order? _dataorden;
  get dataorden => _dataorden;
  int _idSolicitud = 0;
  int get idSolicitud => _idSolicitud;
  int _idProvedor = 0;
  int get idProvedor => _idProvedor;
  String _correoProv = "";
  String get correoProv => _correoProv;
  String _clientSecret = "";
  String get clientSecret => _clientSecret;
  var _contactSOS = {};
  get contactSOS => _contactSOS;
  List<PagosModel> _pagosData = [];
  List<PagosModel> get pagosData => _pagosData;

  Future<void> getOrders() async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('OrdenesT/ObtenerOrdenesClientes?IdCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _data = await jsonData.map((order) {
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
      final response = await _apiService.getData('OrdenesT/ObtenerOrden?IdCliente=$idUser0&IdOrden=$idOrden');

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

  // Método para enviar comentarios
  Future<void> saveComent(int idCliente, int idOrden, String message) async {
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'comentario': message,
      'identificador': "Cliente",
      'idUsuario': idCliente,
      'idTrabajo': idOrden,
    };
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response = await _apiService.postData('OrdenesT/AgregarComentario', data);
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
      final response = await _apiService.getData('Mensajes/ObtenerListaChatCliente?idCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
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
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getChat(int idProv) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getData('Mensajes/ObtenerMensaje?idProveedor=$idProv&idCliente=$idUser0&Identificador=Cliente');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
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
      // // pruwba ws
      // _apiService.sendMessage(data);
      //funciona
      final response = await _apiService.postData('Mensajes/AgregarMensaje', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Mensaje enviado";
        // notifyListeners();
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

  Future<void> saveResenia(int? idProvedor, int rating, String comment) async {
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
      final response = await _apiService.postData('Resenias/AgregarResenia', data);
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

  Future<void> saveReporte(int? idProvedor, String motivoReporte) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {'motivoReporte': motivoReporte, 'idCliente': idUser0, 'idProveedor': idProvedor};
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response = await _apiService.postData('ReporteProveedor/AgregarReporte', data);
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
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('Clientes/ObtenerCliente?idCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final jsonData = jsonResponse['data'];
        _dataClient = ClientModel.fromJson(jsonData);
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

  Future<void> updateClient(String name, String phone, String email, String? selfie) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {'idCliente': idUser0, 'nombre': name, 'telefono': phone, 'correo': email, 'Selfie': selfie};
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response = await _apiService.updateData('Clientes/EditarCliente', data);
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
    Map<String, dynamic> data = {'IdCliente': idUser0, 'OldPassword': oldPass, 'NewPassword': newPass};
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    try {
      final response = await _apiService.updateData('Clientes/CambiarContrasenia', data);
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

  Future<void> getPlans() async {
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    String type = "Cliente";
    notifyListeners();
    try {
      final response = await _apiService.getData('Planes/ObtenerPlanes?typePlan=$type');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _dataPlan = jsonData.map((plan) {
            return PlanModel.fromJson(plan);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
        }
        // _dataPlan = PlanModel.fromJson(jsonData);
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

  Future<void> getServicios() async {
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    String type = "Cliente";
    // notifyListeners();
    try {
      final response = await _apiService.getData('Servicios/ObtenerServiciosClient?typeUser=$type');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _dataServicios = jsonData.map((servicio) {
            return ServiciosModel.fromJson(servicio);
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

  Future<void> getServiciosFiltrados(String servicio, String pais, String estado, String municipio, String amount) async {
    notifyListeners();
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    String service = normalizeString(servicio);

    try {
      final response = await _apiService.getData('Servicios/ObtenerServiciosFiltrados?nombreServicio=$servicio&amount=$amount&country=$pais&city=$estado&province=$municipio');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _serviciosFiltrados = jsonData.map((servicioFilter) {
            return FilterOptionsModel.fromJson(servicioFilter);
          }).toList();
        } catch (e) {
          _errorMessage = 'Error: al mapear los datos';
        }
      } else {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
        // _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getServiciosPopulares() async {
    notifyListeners();
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;

    try {
      final response = await _apiService.getData('Servicios/ObtenerServiciosPopularesFiltrados?idCliente=$idUser0');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _serviciosPopulares = jsonData.map((servicio) {
            return ServiciosPopularModel.fromJson(servicio);
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

  String normalizeString(String input) {
    String uppercased = input.toUpperCase();
    String noAccents = removeDiacritics(uppercased);
    String noSpaces = noAccents.replaceAll(' ', '');
    return noSpaces;
  }

  Future<void> saveSolicitud(int idServicio, int idProvedor, int idCobertura, String createAt) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {'idCliente': idUser0, 'idServicio': idServicio, 'idProvedor': idProvedor, 'idCobertura': idCobertura, 'create_at': createAt};
    notifyListeners();
    try {
      final response = await _apiService.postData('SolicitudServicio/AgregarSolicitud', data);
      int statusCode = response['statusCode'];
      _idSolicitud = int.parse(response['createdId']);
      if (statusCode == 200) {
        _successMessage = "Solicitud enviada";
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

  Future<void> saveOrder(String orden, int idServicio, String direccion, String citaFecha, String recomendacion, String desc, int idProvedor) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {
      'orden': orden,
      'idServicio': idServicio,
      'direccion': direccion,
      'citaFecha': citaFecha,
      'recomendacion': recomendacion,
      'descripcionSolicitud': desc,
      'estado': "Aceptada",
      'idProveedor': idProvedor,
      'idCliente': idUser0,
      'fase': 1,
      'aprobacion': 1,
      'archivo': "",
      'extencionArchivo': "",
      'monto': 0
    };
    notifyListeners();
    try {
      final response = await _apiService.postData('OrdenesT/AgregarOrdenes', data);
      int statusCode = response['statusCode'];
      debugPrint("Respuesta: ${response}");
      if (statusCode == 200) {
        try {
          final jsonData = response['data'];
          _dataorden = Order.fromJson(jsonData);
          // _dataorden = response['data'];
          _successMessage = "La orden se ha guardado correctamente";
          debugPrint("todo bien con la orden");
        } catch (e) {
          debugPrint("Error al mapear: $e");
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatestatusSolicitud(int idSolicitud) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = "";
    _successMessage = "";
    try {
      final response = await _apiService.updateD('SolicitudServicio/EstatusSolicitud?idSolicitud=$idSolicitud&status=3');
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

  Future<void> getDetailMessagge(int idMessage) async {
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getResponse('Mensajes/ObtenerMensajeClient?idCliente=$idUser0&idMensaje=$idMessage');

      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _idProvedor = response['idProvedor'];
        _correoProv = response['correoProvedor'];
      } else {
        _errorMessage = 'Error: $statusCode';
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePago(int amount, String token) async {
    // String? idUser = await _saveLocalService.getData("idUser");
    // int idUser0 = int.tryParse(idUser!) ?? 0;
    print(amount);
    _isLoading = true;
    notifyListeners(); // Notificar a los widgets que el estado ha cambiado
    _errorMessage = "";
    _successMessage = "";
    Map<String, dynamic> data = {'Monto': amount, 'Token': token};
    try {
      final response = await _apiService.postData('PagosSripe/crear-pago', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        print(response);
        _successMessage = "Pago realizado correctamente";
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPaymentIntent(int amount, int idProvedor, int idOrden) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = "";
    _successMessage = "";
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    Map<String, dynamic> data = {'monto': amount, 'token': '', 'idCliente': idUser0, 'idProvedor': idProvedor, 'idOrden': idOrden};
    try {
      final response = await _apiService.postData('PagosSripe/create-payment-intent', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        final secret = response['data'];
        _clientSecret = secret;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrden(int idOrdenTrabajo) async {
    _errorMessage = "";
    _successMessage = "";
    _isLoading = true;
    Map<String, dynamic> data = {'IdOrdenTrabajo': idOrdenTrabajo, 'FasePago': 1, 'Estado': null, 'Archivo': null, 'ExtencionArchivo': null};
    notifyListeners();
    try {
      final response = await _apiService.updateData('OrdenesT/EditarOrden', data);
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

  Future<void> saveContact(String nombre, String numero) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = "";
    _successMessage = "";
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    Map<String, dynamic> data = {'nombreContacto': nombre, 'telefono': numero, 'idCliente': idUser0};
    try {
      final response = await _apiService.postData('ContactEmergent/AgregarContacto', data);
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        _successMessage = "Pago realizado correctamente";
        await _saveLocalService.saveData("contactoName", nombre);
        await _saveLocalService.saveData("contactoPhone", numero);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getContact() async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getResponse('ContactEmergent/ObtenerContacto?idCliente=$idUser0');

      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        debugPrint('todo bien: ${response}');
        _contactSOS = response['data'];
      } else {
        debugPrint('error: $statusCode');
        _errorMessage = 'Error: $statusCode';
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteContacto(int idContacto) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.deleteData('ContactEmergent/EliminarContacto?idContacto=$idContacto');

      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        debugPrint('todo bien: ${response}');
      } else {
        debugPrint('error: $statusCode');
        _errorMessage = 'Error: $statusCode';
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('error: ${e.toString()}');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPayments() async {
    _isLoading = true;
    notifyListeners();
    String? idUser = await _saveLocalService.getData("idUser");
    int idUser0 = int.tryParse(idUser!) ?? 0;
    _errorMessage = '';
    _successMessage = '';
    try {
      final response = await _apiService.getData('PagosSripe/obtenerPagos?idCliente=$idUser0');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'];
        try {
          _pagosData = await jsonData.map((pago) {
            return PagosModel.fromJson(pago);
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
}
