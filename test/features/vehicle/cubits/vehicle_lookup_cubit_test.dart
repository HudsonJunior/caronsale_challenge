import 'package:caronsale/core/utils/failures.dart';
import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/auth/data/models/user.dart';
import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';
import 'package:caronsale/features/vehicle/data/repositories/vehicle_repository.dart';
import 'package:caronsale/features/vehicle/presentation/cubit/vehicle_lookup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late VehicleLookupCubit vehicleLookupCubit;
  late MockVehicleRepository mockVehicleRepository;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockVehicleRepository = MockVehicleRepository();
    mockUserRepository = MockUserRepository();
    vehicleLookupCubit = VehicleLookupCubit();
    GetIt.instance.registerSingleton<VehicleRepository>(mockVehicleRepository);
    GetIt.instance.registerSingleton<UserRepository>(mockUserRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('VehicleLookupCubit', () {
    const testVin = 'TEST123';
    const testEmail = 'test@example.com';
    const testUser = User(id: '123', email: testEmail);
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

    test('initial state is VehicleLookupInitial', () {
      expect(vehicleLookupCubit.state, const VehicleLookupInitial());
    });

    blocTest<VehicleLookupCubit, VehicleLookupState>(
      'emits [VehicleLookupLoading, VehicleLookupError] when user is not logged in',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(null));
        return vehicleLookupCubit;
      },
      act: (cubit) => cubit.lookup(testVin),
      expect: () => [
        const VehicleLookupLoading(),
        const VehicleLookupError(
            'You need to be logged in to use this feature'),
      ],
    );

    blocTest<VehicleLookupCubit, VehicleLookupState>(
      'emits [VehicleLookupLoading, VehicleLookupSuccess] when lookup succeeds with single vehicle',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(testUser));
        when(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .thenAnswer((_) async => Result.ok(([], testVehicle)));
        return vehicleLookupCubit;
      },
      act: (cubit) => cubit.lookup(testVin),
      expect: () => [
        const VehicleLookupLoading(),
        VehicleLookupSuccess(testVehicle),
      ],
      verify: (_) {
        verify(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .called(1);
      },
    );

    blocTest<VehicleLookupCubit, VehicleLookupState>(
      'emits [VehicleLookupLoading, VehicleLookupMultipleChoices] when lookup succeeds with multiple options',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(testUser));
        when(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .thenAnswer((_) async => Result.ok((testOptions, null)));
        return vehicleLookupCubit;
      },
      act: (cubit) => cubit.lookup(testVin),
      expect: () => [
        const VehicleLookupLoading(),
        VehicleLookupMultipleChoices(testOptions),
      ],
      verify: (_) {
        verify(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .called(1);
      },
    );

    blocTest<VehicleLookupCubit, VehicleLookupState>(
      'emits [VehicleLookupLoading, VehicleLookupError] when lookup fails',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(testUser));
        when(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .thenAnswer((_) async =>
                Result.error(const ServerFailure(message: 'Error')));
        return vehicleLookupCubit;
      },
      act: (cubit) => cubit.lookup(testVin),
      expect: () => [
        const VehicleLookupLoading(),
        const VehicleLookupError('Error'),
      ],
      verify: (_) {
        verify(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .called(1);
      },
    );

    blocTest<VehicleLookupCubit, VehicleLookupState>(
      'emits [VehicleLookupLoading, VehicleLookupError] when no vehicle is found',
      build: () {
        when(() => mockUserRepository.get())
            .thenAnswer((_) async => Result.ok(testUser));
        when(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .thenAnswer((_) async => Result.ok(([], null)));
        return vehicleLookupCubit;
      },
      act: (cubit) => cubit.lookup(testVin),
      expect: () => [
        const VehicleLookupLoading(),
        const VehicleLookupError('No vehicle found'),
      ],
      verify: (_) {
        verify(() => mockVehicleRepository.lookup(testVin, testUser.id))
            .called(1);
      },
    );
  });
}
