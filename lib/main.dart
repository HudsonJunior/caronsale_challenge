import 'package:caronsale/core/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caronsale/features/auth/data/sources/user_local_data_source.dart';
import 'package:caronsale/features/auth/data/repositories/user_repository.dart';
import 'package:caronsale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:caronsale/features/auth/presentation/pages/auth_page.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_local_data_source.dart';
import 'package:caronsale/features/vehicle/data/sources/vehicle_remote_data_source.dart';
import 'package:caronsale/features/vehicle/data/repositories/vehicle_repository.dart';
import 'package:caronsale/features/vehicle/presentation/cubit/vehicle_lookup_cubit.dart';
import 'package:caronsale/features/vehicle/presentation/pages/vehicle_lookup_page.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  const flutterSecureStorage = FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Data sources
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(flutterSecureStorage),
  );
  getIt.registerLazySingleton<VehicleLocalDataSource>(
    () => VehicleLocalDataSource(sharedPreferences),
  );
  getIt.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSource(apiClient: ApiClient.instance),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt())..get(),
  );
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepository(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..getUser(),
      child: MaterialApp(
        title: 'CarOnSale',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xff262626),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFfcbf24),
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        ),
        home: const AuthPage(),
        routes: {
          '/vin-lookup': (context) => BlocProvider(
                create: (context) => VehicleLookupCubit(),
                child: const VehicleLookupPage(),
              ),
          '/auth': (context) => const AuthPage(),
        },
      ),
    );
  }
}
