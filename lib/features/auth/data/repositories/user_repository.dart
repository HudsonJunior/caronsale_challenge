import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/auth/data/models/user.dart';
import 'package:caronsale/features/auth/data/sources/user_local_data_source.dart';

/// Repository responsible for managing user authentication data.
///
/// This repository handles user authentication operations such as saving user data,
/// retrieving user information, and logging out. It uses a local data source for
/// persistence and maintains an in-memory cache of the current user.
class UserRepository {
  final UserLocalDataSource localDataSource;

  User? _user;
  User? get user => _user;

  UserRepository(this.localDataSource);

  /// Saves a new user with the given email.
  ///
  /// Creates a new user with a unique ID based on the current timestamp and saves
  /// it to both the local data source and in-memory cache.
  ///
  /// Returns a [Result] containing the created user on success, or an error on failure.
  Future<Result<User>> save(String email) async {
    final now = DateTime.now();
    final user = User(id: now.microsecondsSinceEpoch.toString(), email: email);
    _user = user;
    await localDataSource.save(user);
    return Result.ok(user);
  }

  /// Logs out the current user.
  ///
  /// Clears both the in-memory cache and the local data source.
  Future<void> logout() {
    _user = null;
    return localDataSource.delete();
  }

  /// Retrieves the current user.
  ///
  /// Returns a [Result] containing the user if found, null if no user is logged in,
  /// or an error on failure.
  Future<Result<User?>> get() async {
    final user = await localDataSource.get();

    _user = user;

    return Result.ok(user);
  }
}
