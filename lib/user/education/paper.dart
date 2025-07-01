import 'package:flutter/material.dart';

class PaperBin extends StatelessWidget {
  const PaperBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          title: const Text("Paper Recycling"),
          backgroundColor: Colors.blue.shade700,
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
                  color: Colors.blue.shade400.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Blue Bin",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/paper-bin.png",
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
                      "How to Dispose of Paper",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("• Remove any plastic covers, staples, or clips."),
                    Text("• Flatten cardboard boxes to save space."),
                    Text("• Do not include food-soiled paper or tissues."),
                    Text("• Keep paper dry and clean before disposal."),
                    Text("• Place recyclables into the blue bin."),
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

              // Example 1: Newspaper
              ExpansionTile(
                leading: const Icon(Icons.newspaper, color: Colors.blue),
                title: const Text("Newspaper & Magazines"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Newspapers, magazines, and brochures are recyclable. "
                          "Ensure they are clean and dry.",
                    ),
                  ),
                ],
              ),

              // Example 2: Cardboard Box
              ExpansionTile(
                leading: const Icon(Icons.inventory, color: Colors.blue),
                title: const Text("Cardboard Boxes"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Flatten cardboard boxes before placing them into the bin. "
                          "Remove any packing tape or labels if possible.",
                    ),
                  ),
                ],
              ),

              // Example 3: Office Paper
              ExpansionTile(
                leading: const Icon(Icons.description, color: Colors.blue),
                title: const Text("Office Paper"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Printer paper, notebooks (without plastic covers), and envelopes "
                          "can be recycled in the blue bin.",
                    ),
                  ),
                ],
              ),

              // Example 4: Paper Bags
              ExpansionTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                title: const Text("Paper Bags"),
                children: const [
                  ListTile(
                    title: Text("Description"),
                    subtitle: Text(
                      "Clean paper bags, shopping bags, and packaging paper are accepted. "
                          "Remove handles if they are made of plastic.",
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
