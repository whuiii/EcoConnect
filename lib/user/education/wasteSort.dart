import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/education/glass.dart';
// TODO: Import actual screens for paper, waste, plastic bins

class WasteSort extends StatelessWidget {
  const WasteSort({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // light background for freshness
      appBar: AppBar(
        title: const Text('Recycling Bins'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "♻️ What do you want to recycle today?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                  children: [
                    RecyclingBin(
                      color: 'brown',
                      label: 'Glass',
                      icon: Icons.wine_bar,
                      onTap: () => Get.to(
                            () => const GlassBin(),
                        transition: Transition.zoom,
                      ),
                    ),
                    RecyclingBin(
                      color: 'blue',
                      label: 'Paper',
                      icon: Icons.description,
                      onTap: () {
                        Get.snackbar("Coming Soon", "Paper bin screen not yet implemented.");
                      },
                    ),
                    RecyclingBin(
                      color: 'black',
                      label: 'General Waste',
                      icon: Icons.delete,
                      onTap: () {
                        Get.snackbar("Coming Soon", "General waste bin screen not yet implemented.");
                      },
                    ),
                    RecyclingBin(
                      color: 'orange',
                      label: 'Plastic & Metal',
                      icon: Icons.recycling,
                      onTap: () {
                        Get.snackbar("Coming Soon", "Plastic & Metal bin screen not yet implemented.");
                      },
                    ),
                  ],
                ),
              ),
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
  final IconData icon;
  final VoidCallback onTap;

  const RecyclingBin({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  Color _getBackgroundColor(String color) {
    switch (color) {
      case 'brown':
        return Colors.brown.shade400;
      case 'blue':
        return Colors.blue.shade400;
      case 'black':
        return Colors.grey.shade800;
      case 'orange':
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getBorderColor(String color) {
    switch (color) {
      case 'brown':
        return Colors.brown.shade200;
      case 'blue':
        return Colors.blue.shade200;
      case 'black':
        return Colors.grey.shade500;
      case 'orange':
        return Colors.orange.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.black12,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _getBorderColor(color), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(color),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
