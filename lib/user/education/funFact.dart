import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class FunFactPage extends StatelessWidget {
  final List<String> funFacts = [
    "Recycling one aluminum can saves enough energy to run a TV for 3 hours!",
    "Glass can be recycled endlessly without losing purity or quality.",
    "Plastic waste takes up to 1,000 years to decompose in landfills.",
    "Around 75% of waste is recyclable, but we only recycle about 30%.",
    "Paper can be recycled up to 7 times before fibers become too short.",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          "Fun Facts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with a cute animation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: const [
                  Icon(Icons.lightbulb_outline,
                      size: 50, color: Colors.amberAccent),
                  SizedBox(height: 10),
                  Text(
                    "Did you know?",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Swipeable fun facts list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: funFacts.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 100 * index),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurpleAccent.shade100,
                            Colors.deepPurple.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amberAccent,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              funFacts[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
