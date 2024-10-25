import 'package:shared_preferences/shared_preferences.dart';

class SaveLocalService {
  Future<void> saveData(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key); // Obtener el token guardado
  }

  Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key); // Eliminar el token guardado
  }
}
