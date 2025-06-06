import 'package:caronsale/core/widgets/custom_form_field.dart';
import 'package:caronsale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:caronsale/features/vehicle/presentation/widgets/vehicle_details.dart';
import 'package:caronsale/features/vehicle/presentation/widgets/vehicle_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caronsale/features/vehicle/presentation/cubit/vehicle_lookup_cubit.dart';

class VehicleLookupPage extends StatefulWidget {
  const VehicleLookupPage({super.key});

  @override
  State<VehicleLookupPage> createState() => _VehicleLookupPageState();
}

class _VehicleLookupPageState extends State<VehicleLookupPage> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacementNamed(context, '/auth');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle Lookup'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                'Welcome to CarOnSale!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFormField(
                      controller: _vinController,
                      label: 'VIN',
                      hint: 'Enter the VIN number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a VIN';
                        }
                        if (value.length != 17) {
                          return 'VIN must be 17 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<VehicleLookupCubit>()
                              .lookup(_vinController.text);
                        }
                      },
                      child: const Text('Lookup VIN'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<VehicleLookupCubit, VehicleLookupState>(
                builder: (context, state) {
                  return switch (state) {
                    VehicleLookupLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    VehicleLookupSuccess(vehicle: final vehicle) =>
                      VehicleDetails(vehicle: vehicle),
                    VehicleLookupMultipleChoices(options: final options) =>
                      VehicleOptions(options: options),
                    VehicleLookupError(message: final message) => Center(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
