import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/education/glass.dart';

class WasteSort extends StatelessWidget {
  const WasteSort({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycling Bins')),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            RecyclingBin(
              color: 'brown',
              label: 'Glass',
              onTap: () => Get.to(() => const GlassBin(),transition: Transition.zoom),
            ),
            RecyclingBin(
              color: 'blue',
              label: 'Paper',
              onTap: () => Get.to(() => const GlassBin()), // Replace with PaperBin()
            ),
            RecyclingBin(
              color: 'black',
              label: 'General Waste',
              onTap: () => Get.to(() => const GlassBin()), // Replace with WasteBin()
            ),
            RecyclingBin(
              color: 'orange',
              label: 'Plastic & Metal',
              onTap: () => Get.to(() => const GlassBin()), // Replace with PlasticBin()
            ),
          ],
        ),
      ),
    );
  }
}

class RecyclingBin extends StatelessWidget {
  final String color;
  final String label;
  final VoidCallback onTap;

  const RecyclingBin({
    super.key,
    required this.color,
    required this.label,
    required this.onTap,
  });

  Color _getBackgroundColor(String color) {
    switch (color) {
      case 'brown':
        return Colors.brown.shade500;
      case 'blue':
        return Colors.blue.shade500;
      case 'black':
        return Colors.grey.shade800;
      case 'orange':
        return Colors.orange.shade500;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getBorderColor(String color) {
    switch (color) {
      case 'brown':
        return Colors.brown.shade300;
      case 'blue':
        return Colors.blue.shade300;
      case 'black':
        return Colors.grey.shade400;
      case 'orange':
        return Colors.orange.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ Function is triggered on tap
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _getBorderColor(color), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(color),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
