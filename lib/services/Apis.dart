import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/SaveLocalService.dart';

class ApiService {
  final String baseUrl = "http://localhost:5023/api"; // URL base de tu API
  final SaveLocalService _saveLocalService = SaveLocalService();

  // Método para obtener datos (GET)
  Future<http.Response> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return await http.get(url);
  }

  // Método para enviar datos (POST)
  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data) async {
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
  Future<void> updateData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar los datos');
    }
  }

  // Método para eliminar datos (DELETE)
  Future<void> deleteData(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar los datos');
    }
  }
}
