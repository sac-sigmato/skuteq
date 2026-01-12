import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _idTokenKey = 'id_token';

  static Future<void> saveIdToken(String token) async {
    await _storage.write(key: _idTokenKey, value: token);
  }

  static Future<String?> getIdToken() async {
    return await _storage.read(key: _idTokenKey);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
