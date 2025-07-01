import 'package:flutter/material.dart';

class PlasticBin extends StatelessWidget {
  const PlasticBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: const Text("Plastic Recycling"),
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
                      "assets/images/plastic.png", // Make sure this matches your image!
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
                      "How to Dispose of Plastic",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("• Rinse containers to remove food or drink residue."),
                    Text("• Remove caps and labels if possible."),
                    Text("• Flatten bottles and containers to save space."),
                    Text("• Do not include plastic bags, straws, or polystyrene."),
                    Text("• Place clean items into the orange bin."),
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

              // Example 1: PET Bottles
              ExpansionTile(
                leading: const Icon(Icons.local_drink, color: Colors.orange),
                title: const Text("Plastic Bottles (PET)"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Plastic bottles for water, soft drinks, or juices are recyclable. "
                          "Rinse, remove the caps, and flatten before placing in the bin.",
                    ),
                  ),
                ],
              ),

              // Example 2: Plastic Containers
              ExpansionTile(
                leading: const Icon(Icons.kitchen, color: Colors.orange),
                title: const Text("Plastic Food Containers"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Takeaway boxes, yogurt tubs, and other plastic containers "
                          "should be rinsed and free from food residue.",
                    ),
                  ),
                ],
              ),

              // Example 3: Detergent Bottles
              ExpansionTile(
                leading: const Icon(Icons.cleaning_services, color: Colors.orange),
                title: const Text("Detergent or Shampoo Bottles"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Plastic bottles for household cleaners, shampoos, or body wash "
                          "are acceptable. Rinse thoroughly.",
                    ),
                  ),
                ],
              ),

              // Example 4: Plastic Packaging
              ExpansionTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.orange),
                title: const Text("Rigid Plastic Packaging"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Hard plastic trays, clamshell packaging, and packaging for electronics "
                          "can be recycled if they are clean.",
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
