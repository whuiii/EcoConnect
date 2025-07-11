import 'package:flutter/material.dart';

class GlassBin extends StatelessWidget {
  const GlassBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          title: const Text("Glass Recycling"),
          backgroundColor: Colors.green.shade700,
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
                  color: Colors.brown.shade300.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Brown Bin",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/Glass.png",
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
                      "How to Dispose of Glass",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("• Rinse glass bottles and jars to remove food or liquid residue."),
                    Text("• Remove caps, lids, or pumps – especially plastic or metal ones."),
                    Text("• Do not break the glass. Handle with care to avoid injury."),
                    Text("• Place cleaned glass items into the brown bin."),
                    Text("• Do not include ceramic, Pyrex, mirrors, or window glass."),
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

              // Example 1: Glass Bottle
              ExpansionTile(
                leading: const Icon(Icons.local_drink, color: Colors.brown),
                title: const Text("Glass Bottle"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/EcoConnect_Logo.png",
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Image.asset(
                              "assets/images/EcoConnect_Logo.png",
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Glass bottles such as those used for soda, juice, and wine "
                              "are fully recyclable. Make sure they are clean and empty "
                              "before placing them in the brown bin.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Example 2: Glass Jar
              ExpansionTile(
                leading: const Icon(Icons.kitchen, color: Colors.brown),
                title: const Text("Glass Jar"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Jars from jam, pickles, or sauces are recyclable. "
                          "Remove any food residue and take off plastic lids if possible.",
                    ),
                  ),
                ],
              ),

              // Example 3: Perfume Bottle
              ExpansionTile(
                leading: const Icon(Icons.spa, color: Colors.brown),
                title: const Text("Perfume or Cosmetic Glass Bottle"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Empty perfume or skincare bottles made of glass are accepted. "
                          "Clean and remove pumps if applicable.",
                    ),
                  ),
                ],
              ),

              // Example 4: Colored Glass
              ExpansionTile(
                leading: const Icon(Icons.color_lens, color: Colors.brown),
                title: const Text("Colored Glass (Brown/Green/Clear)"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "All colors of glass (brown, green, clear) are recyclable. "
                          "Do not mix with ceramics or other non-glass materials.",
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
