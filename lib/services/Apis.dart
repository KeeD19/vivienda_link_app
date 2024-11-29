import 'dart:convert';
import 'package:http/http.dart' as http;

import '../env.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  // final String baseUrl = "http://localhost:5023/api"; // Local
  // final String baseUrl = "http://192.168.55.155:5023/api"; // movil
  // // final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:5023/chat'));
  final String baseUrl = "https://exclusifyapi-hhbpfra4cyfrgtdr.eastus-01.azurewebsites.net/api"; // DESARROLLO

  // Método para obtener datos (GET)
  Future<http.Response> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return await http.get(url);
  }

  Future<Map<String, dynamic>> getResponse(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  // Método para enviar datos (POST)
  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  // Método para actualizar datos (PUT)
  Future<Map<String, dynamic>> updateData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  // Método para actualizar datos (PUT)
  Future<Map<String, dynamic>> updateD(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  // Método para eliminar datos (DELETE)
  Future<Map<String, dynamic>> deleteData(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar los datos');
    } else {
      return json.decode(response.body);
    }
  }

  // metodo para oruebas de pagos online
  Future<Map<String, dynamic>> postPayment(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $secretKey', 'Content-Type': 'application/x-www-form-urlencoded'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }
}
