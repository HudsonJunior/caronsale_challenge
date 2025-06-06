import 'dart:convert';
import 'package:caronsale/core/utils/failures.dart';
import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';

class VehicleLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _vehicleKey = 'vehicle';

  const VehicleLocalDataSource(this.sharedPreferences);

  Future<Result<(List<VehicleOption>, Vehicle?)>> get(
    String vin,
    String userId,
  ) async {
    try {
      final jsonVehicleString = sharedPreferences.getString(
        '$_vehicleKey-$vin-$userId',
      );

      if (jsonVehicleString == null) {
        final jsonOptionsString = sharedPreferences.getString(
          '$_vehicleKey-options-$vin-$userId',
        );

        if (jsonOptionsString == null) {
          return Result.ok(([], null));
        }

        final jsonOptions = jsonDecode(jsonOptionsString) as List<dynamic>;
        return Result.ok((
          jsonOptions.map((e) => VehicleOption.fromJson(e)).toList(),
          null,
        ));
      }

      final json = jsonDecode(jsonVehicleString) as Map<String, dynamic>;
      return Result.ok(([], Vehicle.fromJson(json)));
    } catch (e) {
      return Result.error(
        CacheFailure(
          message: 'Failed to get cached vehicle',
          code: e.toString(),
        ),
      );
    }
  }

  Future<Result<void>> saveOptions(
      List<VehicleOption> options, String vin, String userId) async {
    try {
      await sharedPreferences.setStringList(
        '$_vehicleKey-options-$vin-$userId',
        options.map((e) => jsonEncode(e.toJson())).toList(),
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(
        CacheFailure(
          message: 'Failed to save vehicle options',
          code: e.toString(),
        ),
      );
    }
  }

  Future<Result<void>> save(
    Vehicle vehicle,
    String vin,
    String userId,
  ) async {
    try {
      await sharedPreferences.setString(
        '$_vehicleKey-$vin-$userId',
        jsonEncode(vehicle.toJson()),
      );
      return Result.ok(null);
    } catch (e) {
      return Result.error(
        CacheFailure(
          message: 'Failed to cache vehicle',
          code: e.toString(),
        ),
      );
    }
  }
}
