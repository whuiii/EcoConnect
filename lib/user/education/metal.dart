import 'package:flutter/material.dart';

class MetalBin extends StatelessWidget {
  const MetalBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: const Text("Plastic & Metal Recycling"),
          backgroundColor: Colors.orange.shade700,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Orange Bin",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/metal.png",
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Instructions Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How to Dispose of Plastic & Metal",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("• Rinse containers to remove food or liquid residue."),
                    Text("• Remove labels or caps if possible."),
                    Text("• Crush cans or bottles to save space."),
                    Text("• Do not include hazardous waste like paint cans or batteries."),
                    Text("• Place cleaned items into the orange bin."),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Example 1: Aluminium Can
              ExpansionTile(
                leading: const Icon(Icons.local_drink, color: Colors.orange),
                title: const Text("Aluminium Can"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Soft drink or beer cans are fully recyclable. "
                          "Rinse and crush to save space.",
                    ),
                  ),
                ],
              ),

              // Example 2: Tin Can
              ExpansionTile(
                leading: const Icon(Icons.kitchen, color: Colors.orange),
                title: const Text("Tin or Steel Can"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Food cans (soup, vegetables) should be rinsed and placed in the orange bin. "
                          "Remove labels if possible.",
                    ),
                  ),
                ],
              ),

              // Example 3: Plastic Bottle
              ExpansionTile(
                leading: const Icon(Icons.local_drink, color: Colors.orange),
                title: const Text("Plastic Bottle"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Water, juice, or detergent bottles can be recycled. "
                          "Remove caps and flatten bottles before disposal.",
                    ),
                  ),
                ],
              ),

              // Example 4: Food Packaging
              ExpansionTile(
                leading: const Icon(Icons.fastfood, color: Colors.orange),
                title: const Text("Plastic Food Packaging"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Clean plastic containers, trays, or tubs are acceptable. "
                          "Rinse to remove any leftover food.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
