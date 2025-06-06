import 'package:caronsale/features/auth/data/models/user.dart';
import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'auth_state.dart';

/// Cubit responsible for managing authentication state and operations.
///
/// This cubit handles user authentication operations such as saving user data,
/// retrieving user information, and logging out. It maintains the current
/// authentication state and emits appropriate states based on operation results.
class AuthCubit extends Cubit<AuthState> {
  final UserRepository repository = GetIt.instance<UserRepository>();

  AuthCubit() : super(const AuthInitial());

  /// Saves a new user to the system.
  ///
  /// Creates a new user with the provided [email] and saves it using the repository.
  /// Emits [AuthLoading] while the operation is in progress, [AuthSuccess] on success,
  /// or [AuthError] if the operation fails.
  Future<void> saveUser(String email) async {
    emit(const AuthLoading());

    await Future.delayed(const Duration(seconds: 2));

    final result = await repository.save(email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Logs out the current user.
  ///
  /// Clears the current user data from the repository and emits [AuthInitial] state.
  Future<void> logout() async {
    await repository.logout();
    emit(const AuthInitial());
  }

  /// Retrieves the current user.
  ///
  /// Attempts to get the current user from the repository.
  /// Emits [AuthLoading] while the operation is in progress, [AuthSuccess] if a user
  /// is found, or [AuthError] if no user is found.
  Future<void> getUser() async {
    emit(const AuthLoading());

    final result = await repository.get();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
