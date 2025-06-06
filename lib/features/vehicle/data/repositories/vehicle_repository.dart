import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_local_data_source.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_remote_data_source.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';

/// Repository responsible for managing vehicle data.
///
/// This repository handles vehicle lookup operations, combining remote and local data sources.
/// It implements a caching strategy where remote data is preferred, but local data is used
/// as a fallback when remote operations fail.
class VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final VehicleLocalDataSource localDataSource;

  const VehicleRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Looks up a vehicle by its VIN (Vehicle Identification Number).
  ///
  /// First attempts to fetch data from the remote source. If successful, caches the data
  /// locally. If the remote source fails, falls back to the local cache.
  ///
  /// Returns a [Result] containing a tuple of:
  /// - A list of [VehicleOption]s (empty if no options found)
  /// - A [Vehicle] object (null if no exact match found)
  ///
  /// If both remote and local sources fail, returns an error.
  Future<Result<(List<VehicleOption>, Vehicle?)>> lookup(
    String vin,
    String userId,
  ) async {
    final result = await remoteDataSource.get(vin, userId);

    return result.fold(
      (error) async {
        final cachedResult = await localDataSource.get(vin, userId);

        return cachedResult.fold(
          (cachedError) => Result.error(cachedError),
          (data) {
            final (options, vehicle) = data;

            if (vehicle == null && options.isEmpty) {
              return Result.error(error);
            }

            return Result.ok((options, vehicle));
          },
        );
      },
      (value) async {
        final (options, vehicle) = value;
        if (vehicle != null) {
          await localDataSource.save(vehicle, vin, userId);
        }

        if (options.isNotEmpty) {
          await localDataSource.saveOptions(options, vin, userId);
        }

        return Result.ok(value);
      },
    );
  }
}
