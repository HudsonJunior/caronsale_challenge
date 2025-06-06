import 'package:caronsale/core/utils/failures.dart';
import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';
import 'package:caronsale/features/vehicle/data/repositories/vehicle_repository.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_local_data_source.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRemoteDataSource extends Mock
    implements VehicleRemoteDataSource {}

class MockVehicleLocalDataSource extends Mock
    implements VehicleLocalDataSource {}

void main() {
  late VehicleRepository repository;
  late MockVehicleRemoteDataSource mockRemoteDataSource;
  late MockVehicleLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockVehicleRemoteDataSource();
    mockLocalDataSource = MockVehicleLocalDataSource();
    repository = VehicleRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('VehicleRepository', () {
    const testVin = 'TEST123';
    const testUserId = 'user123';
    final testVehicle = Vehicle(
      id: 1,
      make: 'Toyota',
      model: 'Camry',
      externalId: testVin,
      price: 25000,
      valuatedAt: DateTime.now(),
      requestedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      origin: 'test',
      estimationRequestId: 'test123',
    );
    final testOptions = [
      const VehicleOption(
        make: 'Toyota',
        model: 'Camry',
        containerName: 'Sedan',
        similarity: 95,
        externalId: '1',
      ),
      const VehicleOption(
        make: 'Toyota',
        model: 'Camry LE',
        containerName: 'Sedan',
        similarity: 90,
        externalId: '2',
      ),
    ];

    test('lookup should return remote data when successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.get(testVin, testUserId))
          .thenAnswer((_) async => Result.ok((testOptions, testVehicle)));
      when(() => mockLocalDataSource.save(testVehicle, testVin, testUserId))
          .thenAnswer((_) async => Result.ok(null));
      when(() =>
              mockLocalDataSource.saveOptions(testOptions, testVin, testUserId))
          .thenAnswer((_) async => Result.ok(null));

      // Act
      final result = await repository.lookup(testVin, testUserId);

      // Assert
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (data) {
          final (options, vehicle) = data;
          expect(options, testOptions);
          expect(vehicle, testVehicle);
        },
      );
      verify(() => mockRemoteDataSource.get(testVin, testUserId)).called(1);
      verify(() => mockLocalDataSource.save(testVehicle, testVin, testUserId))
          .called(1);
      verify(() =>
              mockLocalDataSource.saveOptions(testOptions, testVin, testUserId))
          .called(1);
    });

    test('lookup should return cached data when remote fails and cache exists',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.get(testVin, testUserId)).thenAnswer(
          (_) async =>
              Result.error(const ServerFailure(message: 'Remote error')));
      when(() => mockLocalDataSource.get(testVin, testUserId))
          .thenAnswer((_) async => Result.ok((testOptions, testVehicle)));

      // Act
      final result = await repository.lookup(testVin, testUserId);

      // Assert
      result.fold(
        (error) => fail('Expected success but got error: $error'),
        (data) {
          final (options, vehicle) = data;
          expect(options, testOptions);
          expect(vehicle, testVehicle);
        },
      );
      verify(() => mockRemoteDataSource.get(testVin, testUserId)).called(1);
      verify(() => mockLocalDataSource.get(testVin, testUserId)).called(1);
    });

    test('lookup should return error when both remote and cache fail',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.get(testVin, testUserId)).thenAnswer(
          (_) async =>
              Result.error(const ServerFailure(message: 'Remote error')));
      when(() => mockLocalDataSource.get(testVin, testUserId)).thenAnswer(
          (_) async =>
              Result.error(const CacheFailure(message: 'Cache error')));

      // Act
      final result = await repository.lookup(testVin, testUserId);

      // Assert
      result.fold(
        (error) => expect(error.message, 'Cache error'),
        (data) => fail('Expected error but got success: $data'),
      );
      verify(() => mockRemoteDataSource.get(testVin, testUserId)).called(1);
      verify(() => mockLocalDataSource.get(testVin, testUserId)).called(1);
    });
  });
}
