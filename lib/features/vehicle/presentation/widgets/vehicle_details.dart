import 'package:flutter/material.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle.dart';

class VehicleDetails extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetails({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.make} ${vehicle.model}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: \$${vehicle.price}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Origin', value: vehicle.origin),
                  if (vehicle.positiveCustomerFeedback != null)
                    _InfoRow(
                      label: 'Customer Feedback',
                      value: vehicle.positiveCustomerFeedback ?? false
                          ? 'Positive'
                          : 'Negative',
                    ),
                  if (vehicle.feedback != null)
                    _InfoRow(label: 'Feedback', value: vehicle.feedback ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
