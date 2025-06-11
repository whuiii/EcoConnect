import 'package:flutter/material.dart';

// WasteItem data model
class WasteItem {
  final String name;
  final String category;
  final String binColor;
  final String imagePath;

  WasteItem({
    required this.name,
    required this.category,
    required this.binColor,
    required this.imagePath,
  });
}

// Sample waste data
final List<WasteItem> wasteItems = [
  WasteItem(
    name: "Paper",
    category: "Recyclable",
    binColor: "Blue",
    imagePath: "assets/images/EcoConnect_Logo.png",
  ),
  WasteItem(
    name: "Plastic Bottle",
    category: "Recyclable",
    binColor: "Yellow",
    imagePath: "assets/images/EcoConnect_Logo.png",
  ),
  WasteItem(
    name: "Glass",
    category: "Recyclable",
    binColor: "Brown",
    imagePath: "assets/images/EcoConnect_Logo.png",
  ),
  WasteItem(
    name: "Battery",
    category: "Hazardous",
    binColor: "Red",
    imagePath: "assets/images/EcoConnect_Logo.png",
  ),
  WasteItem(
    name: "Food Waste",
    category: "General",
    binColor: "Green",
    imagePath: "assets/images/EcoConnect_Logo.png",
  ),
];

// Main screen widget
class WasteEducationScreen extends StatelessWidget {
  const WasteEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How to Sort Waste"),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        itemCount: wasteItems.length,
        itemBuilder: (context, index) {
          final item = wasteItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Image.asset(item.imagePath, width: 50, height: 50, fit: BoxFit.contain),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${item.category} Waste - ${item.binColor} Bin"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: getBinColor(item.binColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.binColor,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper to get bin color
  Color getBinColor(String binColor) {
    switch (binColor.toLowerCase()) {
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.orangeAccent;
      case "brown":
        return Colors.brown;
      case "grey":
        return Colors.grey;
      case "green":
        return Colors.green;
      case "red":
        return Colors.red;
      case "black":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}
