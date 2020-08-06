import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> clearStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('[clearStorage] Success clear');
    } catch (e) {
      print('[clearStorage] Error Occurred $e');
    }
  }

  Future<void> setString(String key, String value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print('[setString] Success SetString');
    } catch (e) {
      print('[setString] Error Occurred $e');
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
      print('[setInt] Success SetString');
    } catch (e) {
      print('[setInt] Error Occurred $e');
    }
  }

  Future<void> setDouble(String key, double value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
      print('[setDouble] Success SetString');
    } catch (e) {
      print('[setDouble] Error Occurred $e');
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
      print('[setBool] Success SetString');
    } catch (e) {
      print('[setBool] Error Occurred $e');
    }
  }

  Future<String> getString(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(key);

      return data;
    } catch (e) {
      print('[getString] Error Occurred $e');
      return null;
    }
  }

  Future<int> getInt(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = prefs.getInt(key);

      return data;
    } catch (e) {
      print('[getInt] Error Occurred $e');
      return null;
    }
  }

  Future<double> getDouble(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = prefs.getDouble(key);

      return data;
    } catch (e) {
      print('[getDouble] Error Occurred $e');
      return null;
    }
  }

  Future<bool> getBool(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = prefs.getBool(key);

      return data;
    } catch (e) {
      print('[getDouble] Error Occurred $e');
      return null;
    }
  }
}
