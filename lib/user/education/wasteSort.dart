import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/user/education/glass.dart';
import 'package:navigate/user/education/metal.dart';
import 'package:navigate/user/education/organic.dart';
import 'package:navigate/user/education/paper.dart';
import 'package:navigate/user/education/plastic.dart';
// TODO: Import actual screens for paper, waste, plastic bins when ready

class WasteSort extends StatelessWidget {
  const WasteSort({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.green.shade50, // light background
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
                      icon: 'assets/images/glass-bin.png',
                      onTap: () => Get.to(
                            () => const GlassBin(),
                        transition: Transition.zoom,
                      ),
                    ),
                    RecyclingBin(
                      color: 'blue',
                      label: 'Paper',
                      icon: 'assets/images/paper-bin.png',
                      onTap: () {
                        Get.to(PaperBin());
                      },
                    ),
                    RecyclingBin(
                      color: 'black',
                      label: 'General Waste',
                      icon: 'assets/images/organic.png',
                      onTap: () {
                        Get.to(OrganicBin());
                      },
                    ),
                    RecyclingBin(
                      color: 'orange',
                      label: 'Metal',
                      icon: 'assets/images/metal.png',
                      onTap: () {
                        Get.to(MetalBin());
                      },
                    ),
                    RecyclingBin(
                      color: 'yellow',
                      label: 'Plastic',
                      icon: 'assets/images/plastic.png',
                      onTap: () {
                        Get.to(PlasticBin());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class RecyclingBin extends StatelessWidget {
  final String color;
  final String label;
  final String icon;
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
      case 'yellow':
        return Colors.yellow.shade400;
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
      case 'yellow':
        return Colors.yellow.shade400;
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
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _getBackgroundColor(color),
                  backgroundImage: AssetImage(icon),
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
