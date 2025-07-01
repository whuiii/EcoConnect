import 'package:flutter/material.dart';

class OrganicBin extends StatelessWidget {
  const OrganicBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Organic / General Waste"),
          backgroundColor: Colors.grey.shade800,
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
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Black Bin",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/organic.png", // Make sure this exists!
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
                      "How to Dispose of Organic / General Waste",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("• Place non-recyclable waste into the black bin."),
                    Text("• Wrap wet waste to avoid leaks or odor."),
                    Text("• Do not include recyclables like paper, plastic, or glass."),
                    Text("• Hazardous waste like batteries or electronics should be disposed of separately."),
                    Text("• Compost organic kitchen waste if possible to reduce landfill waste."),
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

              // Example 1: Food Waste
              ExpansionTile(
                leading: const Icon(Icons.restaurant, color: Colors.grey),
                title: const Text("Food Scraps"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Leftover food, fruit peels, vegetable scraps, and expired food items "
                          "should go into the black bin if you can't compost them.",
                    ),
                  ),
                ],
              ),

              // Example 2: Used Tissues
              ExpansionTile(
                leading: const Icon(Icons.clean_hands, color: Colors.grey),
                title: const Text("Used Tissues & Paper Towels"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Used tissues, napkins, and paper towels cannot be recycled and should go into the black bin.",
                    ),
                  ),
                ],
              ),

              // Example 3: Diapers
              ExpansionTile(
                leading: const Icon(Icons.baby_changing_station, color: Colors.grey),
                title: const Text("Diapers & Sanitary Products"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Used diapers and sanitary products must be securely wrapped "
                          "and disposed of in the black bin.",
                    ),
                  ),
                ],
              ),

              // Example 4: Contaminated Packaging
              ExpansionTile(
                leading: const Icon(Icons.delete, color: Colors.grey),
                title: const Text("Contaminated Packaging"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Pizza boxes, food-soiled paper plates, and plastic containers with leftover food "
                          "cannot be recycled. Dispose of these in the black bin.",
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
