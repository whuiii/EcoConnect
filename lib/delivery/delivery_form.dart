import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Make sure to add iconsax package in pubspec.yaml

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Delivery Form"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep,
                steps: getStep(),
                controlsBuilder: (context, _) {
                  return SizedBox.shrink(); // Hides default Continue/Cancel buttons
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentStep == 0
                        ? null
                        : () => setState(() => currentStep -= 1),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isLastStep = currentStep == getStep().length - 1;
                      if (isLastStep) {
                        print("Completed");
                        // You can navigate or show dialog here
                      } else {
                        setState(() => currentStep += 1);
                      }
                    },
                    child: Text(currentStep == getStep().length - 1 ? "Finish" : "Continue"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<Step> getStep() => [
    Step(
      isActive: currentStep >= 0,
      title: Text("Account"),
      content: Column(
        children: [
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Email",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Iconsax.sms,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "Username",
              prefixIcon: Icon(
                Iconsax.user,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 1,
      title: Text("Detail"),
      content: Column(
        children: [
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: "Address",
              hintText: "Your address",
              prefixIcon: Icon(
                Iconsax.location,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Phone Number",
              prefixIcon: Icon(
                Iconsax.call,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 2,
      title: Text("Complete"),
      content: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 48),
          SizedBox(height: 10),
          Text(
            "All steps completed!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  ];
}
