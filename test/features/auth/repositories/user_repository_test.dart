import 'package:caronsale/features/auth/data/models/user.dart';
import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:caronsale/features/auth/data/sources/user_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late UserRepository repository;
  late MockUserLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    repository = UserRepository(mockLocalDataSource);
  });

  group('UserRepository', () {
    const testUser = User(id: '123', email: 'test@example.com');

    test('save should store user and return success', () async {
      // Arrange
      when(() => mockLocalDataSource.save(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.save('test@example.com');

      // Assert
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (user) {
          expect(user.email, 'test@example.com');
        },
      );
      verify(() => mockLocalDataSource.save(any())).called(1);
    });

    test('logout should clear user and call local data source', () async {
      // Arrange
      when(() => mockLocalDataSource.delete()).thenAnswer((_) async {});

      // Act
      await repository.logout();

      // Assert
      expect(repository.user, null);
      verify(() => mockLocalDataSource.delete()).called(1);
    });

    test('get should return user from local data source', () async {
      // Arrange
      when(() => mockLocalDataSource.get()).thenAnswer((_) async => testUser);

      // Act
      final result = await repository.get();

      // Assert
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (user) {
          expect(user, testUser);
          expect(repository.user, testUser);
        },
      );
      verify(() => mockLocalDataSource.get()).called(1);
    });

    test('get should return null when local data source returns null',
        () async {
      // Arrange
      when(() => mockLocalDataSource.get()).thenAnswer((_) async => null);

      // Act
      final result = await repository.get();

      // Assert
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (user) {
          expect(user, null);
          expect(repository.user, null);
        },
      );
      verify(() => mockLocalDataSource.get()).called(1);
    });
  });
}
