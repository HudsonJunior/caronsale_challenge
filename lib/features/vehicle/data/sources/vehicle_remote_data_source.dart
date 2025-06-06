import 'dart:async';
import 'dart:convert';
import 'package:caronsale/core/api/api_client.dart';
import 'package:caronsale/core/utils/failures.dart';
import 'package:caronsale/core/utils/result.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';

class VehicleRemoteDataSource {
  final ApiClient apiClient;

  const VehicleRemoteDataSource({required this.apiClient});

  Future<Result<(List<VehicleOption>, Vehicle?)>> get(
    String vin,
    String userId,
  ) async {
    try {
      final response = await apiClient.httpClient.get(
        Uri.https('api.caronsale.de', '/vehicle/$vin'),
        headers: {ApiClient.user: userId},
      );

      if (response.statusCode == 300) {
        return Result.ok(
          (
            List<Map<String, dynamic>>.from(
              json.decode(response.body) as List,
            ).map((e) => VehicleOption.fromJson(e)).toList(),
            null,
          ),
        );
      }

      if (response.statusCode >= 400) {
        final body = json.decode(response.body);
        return Result.error(
          ServerFailure(
            message: 'Failed to lookup Vehicle - ${body['message']}',
            code: response.statusCode.toString(),
          ),
        );
      }

      return Result.ok(
        (
          [],
          Vehicle.fromJson(
            json.decode(response.body),
          ),
        ),
      );
    } on TimeoutException catch (e) {
      return Result.error(
        ServerFailure(
          message: 'Failed to lookup Vehicle - Please try again later',
          code: e.toString(),
        ),
      );
    } catch (e) {
      return Result.error(
        ServerFailure(
          message: 'Failed to lookup Vehicle',
          code: e.toString(),
        ),
      );
    }
  }
}
