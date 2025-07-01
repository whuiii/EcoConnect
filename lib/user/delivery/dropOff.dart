import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DropOffCenters extends StatelessWidget {
  const DropOffCenters({super.key});

  final centers = const [
    {
      'name': 'Eco Green Recycling Center',
      'address': 'No. 12, Jalan Hijau, Kuala Lumpur',
    },
    {
      'name': 'City Waste Collection Hub',
      'address': 'Lot 22, Jalan Bandar, Shah Alam',
    },
    {
      'name': 'Go Recycle Facility',
      'address': 'Taman Perindustrian Eco, Penang',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drop-Off Centers")),
      body: Container(
        key: const ValueKey("dropoff"),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.separated(
          itemCount: centers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final center = centers[index];
            return ListTile(
              leading: const Icon(Iconsax.location, color: Colors.teal),
              title: Text(center['name']!),
              subtitle: Text(center['address']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${center['name']}')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
