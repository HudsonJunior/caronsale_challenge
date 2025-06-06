import 'package:flutter/material.dart';
import 'package:caronsale/features/vehicle/data/models/vehicle_option.dart';

class VehicleOptions extends StatelessWidget {
  final List<VehicleOption> options;

  const VehicleOptions({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Card(
          child: ListTile(
            title: Text('${option.make} ${option.model}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Container: ${option.containerName}'),
                Text('Similarity: ${option.similarity}%'),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement option selection
            },
          ),
        );
      },
    );
  }
}
