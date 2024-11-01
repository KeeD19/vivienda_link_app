import 'package:shared_preferences/shared_preferences.dart';

class SaveLocalService {
  Future<void> saveData(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(key);
    if (id == null) {
      return "0";
    } else {
      return id;
    }
  }

  Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key); // Eliminar el token guardado
  }
}
