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
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> save(User user) async {
    try {
      await flutterSecureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {}
  }

  Future<void> delete() async {
    try {
      await flutterSecureStorage.delete(key: _userKey);
    } catch (e) {}
  }
}
