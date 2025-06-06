part of 'vehicle_lookup_cubit.dart';

abstract class VehicleLookupState extends Equatable {
  const VehicleLookupState();

  @override
  List<Object?> get props => [];
}

class VehicleLookupInitial extends VehicleLookupState {
  const VehicleLookupInitial();
}

class VehicleLookupLoading extends VehicleLookupState {
  const VehicleLookupLoading();
}

class VehicleLookupSuccess extends VehicleLookupState {
  final Vehicle vehicle;

  const VehicleLookupSuccess(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleLookupMultipleChoices extends VehicleLookupState {
  final List<VehicleOption> options;

  const VehicleLookupMultipleChoices(this.options);

  @override
  List<Object?> get props => [options];
}

class VehicleLookupError extends VehicleLookupState {
  final String message;

  const VehicleLookupError(this.message);

  @override
  List<Object?> get props => [message];
}
