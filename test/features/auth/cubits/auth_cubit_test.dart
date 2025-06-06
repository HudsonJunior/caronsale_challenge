import 'package:caronsale/core/utils/failures.dart';
import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/auth/data/models/user.dart';
import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:caronsale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late AuthCubit authCubit;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    authCubit = AuthCubit();
    GetIt.instance.registerSingleton<UserRepository>(mockUserRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('AuthCubit', () {
    const testEmail = 'test@example.com';
    const testUser = User(id: '123', email: testEmail);

    test('initial state is AuthInitial', () {
      expect(authCubit.state, const AuthInitial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when saveUser succeeds',
      build: () {
        when(() => mockUserRepository.save(testEmail))
            .thenAnswer((_) async => Result.ok(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.saveUser(testEmail),
      expect: () => [
        const AuthLoading(),
        const AuthSuccess(testUser),
      ],
      verify: (_) {
        verify(() => mockUserRepository.save(testEmail)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when saveUser fails',
      build: () {
        when(() => mockUserRepository.save(testEmail)).thenAnswer(
            (_) async => Result.error(const ServerFailure(message: 'Error')));
        return authCubit;
      },
      act: (cubit) => cubit.saveUser(testEmail),
      expect: () => [
        const AuthLoading(),
        const AuthError('Error'),
      ],
      verify: (_) {
        verify(() => mockUserRepository.save(testEmail)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthInitial] when logout is called',
      build: () {
        when(() => mockUserRepository.logout()).thenAnswer((_) async {});
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthInitial(),
      ],
      verify: (_) {
        verify(() => mockUserRepository.logout()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when getUser succeeds',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => [
        const AuthLoading(),
        const AuthSuccess(testUser),
      ],
      verify: (_) {
        verify(() => mockUserRepository.get()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when getUser fails',
      build: () {
        when(() => mockUserRepository.get()).thenAnswer(
            (_) async => Result.error(const ServerFailure(message: 'Error')));
        return authCubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => [
        const AuthLoading(),
        const AuthError('Error'),
      ],
      verify: (_) {
        verify(() => mockUserRepository.get()).called(1);
      },
    );
  });
}
