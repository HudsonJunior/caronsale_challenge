import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:caronsale/features/auth/data/models/user.dart';

class UserLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  static const String _userKey = 'user';

  UserLocalDataSource(this.flutterSecureStorage);

  Future<User?> get() async {
    try {
      final jsonString = await flutterSecureStorage.read(key: _userKey);
      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return User(
        id: json['id'] as String,
        email: json['name'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> save(User user) async {
    try {
      final json = {
        'id': user.id,
        'name': user.email,
      };
      await flutterSecureStorage.write(key: _userKey, value: jsonEncode(json));
    } catch (e) {}
  }

  Future<void> delete() async {
    try {
      await flutterSecureStorage.delete(key: _userKey);
    } catch (e) {}
  }
}
