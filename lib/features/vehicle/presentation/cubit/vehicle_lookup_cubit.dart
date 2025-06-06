import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';
import 'package:caronsale/features/vehicle/data/repositories/vehicle_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'vehicle_lookup_state.dart';

/// Cubit responsible for managing vehicle lookup operations.
///
/// This cubit handles the process of looking up vehicles by VIN, including handling
/// cases where multiple vehicle options are found or when errors occur during the lookup.
/// It maintains the current lookup state and emits appropriate states based on operation results.
class VehicleLookupCubit extends Cubit<VehicleLookupState> {
  final VehicleRepository repository = GetIt.instance<VehicleRepository>();
  final UserRepository userRepository = GetIt.instance<UserRepository>();

  VehicleLookupCubit() : super(const VehicleLookupInitial());

  /// Looks up a vehicle by its VIN (Vehicle Identification Number).
  ///
  /// First checks if a user is logged in. If not, emits [VehicleLookupError].
  /// If a user is logged in, attempts to look up the vehicle using the repository.
  /// Emits appropriate states based on the lookup result:
  /// - [VehicleLookupLoading] while the operation is in progress
  /// - [VehicleLookupSuccess] if a single vehicle is found
  /// - [VehicleLookupMultipleChoices] if multiple vehicle options are found
  /// - [VehicleLookupError] if the lookup fails or no vehicle is found
  Future<void> lookup(String vin) async {
    emit(const VehicleLookupLoading());

    final user = userRepository.user;
    if (user == null) {
      emit(
        const VehicleLookupError(
          'You need to be logged in to use this feature',
        ),
      );
      return;
    }

    final result = await repository.lookup(vin, user.id);

    result.fold(
      (failure) => emit(VehicleLookupError(failure.message)),
      (data) {
        final (options, vehicle) = data;

        if (options.isNotEmpty) {
          options.sort((a, b) => b.similarity.compareTo(a.similarity));
          emit(VehicleLookupMultipleChoices(options));
        } else if (vehicle != null) {
          emit(VehicleLookupSuccess(vehicle));
        } else {
          emit(const VehicleLookupError('No vehicle found'));
        }
      },
    );
  }
}
