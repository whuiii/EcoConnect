import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Optional: for modern icons
import 'package:navigate/color.dart';
import 'package:navigate/user/delivery/pickup_page.dart';
import 'package:navigate/user/delivery/drop_off_list.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String? deliveryOption;

  void _continue() {
    if (deliveryOption == "Pick-Up") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickUpForm()),
      );
    } else if (deliveryOption == "Drop-Off") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DropOffCenters()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a delivery option")),
      );
    }
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required String optionValue,
  }) {
    final isSelected = deliveryOption == optionValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          deliveryOption = optionValue;
        });
      },
      child: Card(
        elevation: isSelected ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? green2 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? green2 : Colors.grey.shade700,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? green2 : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: green2, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Delivery Option"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How would you like to deliver your recyclables?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _buildOptionCard(
              title: "Pick-Up Service",
              description:
                  "We’ll come to your location to collect your recyclables.",
              icon: Iconsax.truck, // uses iconsax, can change
              optionValue: "Pick-Up",
            ),
            SizedBox(height: 20),
            _buildOptionCard(
              title: "Self Drop-Off",
              description: "You can drop off your recyclables at our centers.",
              icon: Iconsax.location5, // uses iconsax, can change
              optionValue: "Drop-Off",
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _continue,
                label: Text("Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green2,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
