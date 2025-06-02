import 'package:flutter/material.dart';

class GlassBin extends StatelessWidget {
  const GlassBin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Glass")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Brown Bin",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Image.asset("assets/images/Glass.png", height: 100),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How to Dispose Glass",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("• Rinse glass bottles and jars to remove food or liquid residue."),
                    Text("• Remove caps, lids, or pumps – especially plastic or metal ones."),
                    Text("• Do not break the glass. Handle with care to avoid injury."),
                    Text("• Place cleaned glass items into the brown bin."),
                    Text("• Do not include ceramic, Pyrex, mirrors, or window glass."),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Example 1: Glass Bottle
              ExpansionTile(
                leading: Icon(Icons.local_drink),
                title: Text("Glass Bottle"),
                children:[
                  Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/EcoConnect_Logo.png", // Your image path
                              height: 150,
                              fit: BoxFit.cover,
                            ),

                            Image.asset(
                              "assets/images/EcoConnect_Logo.png", // Your image path
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Glass bottles such as those used for soda, juice, and wine are fully recyclable. "
                            "Make sure they are clean and empty before placing them in the brown bin.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ],
              ),

              // Example 2: Glass Jar
              ExpansionTile(
                leading: Icon(Icons.kitchen),
                title: Text("Glass Jar"),
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
                leading: Icon(Icons.spa),
                title: Text("Perfume or Cosmetic Glass Bottle"),
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
                leading: Icon(Icons.color_lens),
                title: Text("Colored Glass (Brown/Green/Clear)"),
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
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
