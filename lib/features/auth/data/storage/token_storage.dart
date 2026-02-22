import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../dto/auth_token_dto.dart';

class TokenStorage {
  static const _tokenKey = 'demo_auth_token';

  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  Future<void> saveToken(String token) async {
    final dto = AuthTokenDto(token: token, savedAt: DateTime.now());
    await _secureStorage.write(key: _tokenKey, value: jsonEncode(dto.toJson()));
  }

  Future<AuthTokenDto?> readToken() async {
    final raw = await _secureStorage.read(key: _tokenKey);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return AuthTokenDto.fromJson(decoded);
  }

  Future<void> deleteToken() => _secureStorage.delete(key: _tokenKey);
}
