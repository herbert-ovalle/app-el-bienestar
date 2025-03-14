import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SaveLocal {
  final storage = FlutterSecureStorage();

  Future<void> save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> get(String key) async {
    String value = await storage.read(key: key) ?? "";
    return value;
  }

  Future<Map<String, String>> readAll(String key) async {
    return await storage.readAll();
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: key);
  }

  Future<void> deleteSession() async {
    await delete("token");
    await delete("idSession");
    await delete("user");   
  }
}
