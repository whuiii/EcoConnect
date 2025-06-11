import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location/location.dart';
import 'package:navigate/color.dart';
import 'package:navigate/delivery/bagsize_roundcheck.dart';
import 'package:navigate/delivery/dateTimePicker.dart';
import 'package:navigate/delivery/placeholder_delivery.dart'; // Make sure to add iconsax package in pubspec.yaml

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  int currentStep = 0;
  bool? isPlastic = false;
  bool? isAluminium = false;
  bool? isPaper = false;

  Location location = new Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  Future<void> _requestLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    //location service is enabled
    _locationData = await location.getLocation();
    setState(() {

    });
  }

  // late String lat;
  // late String long;
  // String locationMessage = "Current Location of the User";
  //
  // Future<Position> _getCurrentLocation() async{
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if(!serviceEnabled){
  //     return Future.error("Location services are disabled");
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied){
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied){
  //       return Future.error("Location permission are denied");
  //     }
  //
  //   }
  //
  //   if(permission == LocationPermission.deniedForever){
  //     return Future.error("Location permissios are permanently denied, we cannot request to access");
  //
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Delivery Form"),
          backgroundColor: primary,
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
                  return SizedBox
                      .shrink(); // Hides default Continue/Cancel buttons
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
                    child: Text(currentStep == getStep().length - 1
                        ? "Finish"
                        : "Continue"),
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
              FillInBlank(text: "Email", hint: "Email", icon: Iconsax.sms),
              SizedBox(height: 16),
              FillInBlank(text: "Username", hint: "Email", icon: Iconsax.user),
              SizedBox(height: 16),
              FillInBlank(
                  text: "Phone Number",
                  hint: "Phone Number",
                  icon: Iconsax.call),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Text("Recyclable Materials:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Column(
                children: [
                  Row(children: [
                    Checkbox(
                      value: isPlastic,
                      onChanged: (bool? value) {
                        setState(() {
                          isPlastic = value;
                        });
                      },
                      activeColor: Colors.orange, // fill color when checked
                      checkColor: Colors.white, // tick mark color
                    ),
                    Text(
                      "Plastic",
                      style: TextName,
                    ),
                  ]),
                  Row(children: [
                    Checkbox(
                      value: isAluminium,
                      onChanged: (bool? value) {
                        setState(() {
                          isAluminium = value;
                        });
                      },
                      activeColor: Colors.brown, // fill color when checked
                      checkColor: Colors.white, // tick mark color
                    ),
                    Text(
                      "Aluminium",
                      style: TextName,
                    ),
                  ]),
                  Row(children: [
                    Checkbox(
                      value: isPaper,
                      onChanged: (bool? value) {
                        setState(() {
                          isPaper = value;
                        });
                      },
                      activeColor: Colors.blue, // fill color when checked
                      checkColor: Colors.white, // tick mark color
                    ),
                    Text(
                      "Paper",
                      style: TextName,
                    ),
                  ]),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Text("Estimated Quantity",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              BagSizeSelector(),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: Text("Detail"),
          content: Column(
            children: [
              DateTimePickerWidget(),
              SizedBox(height: 20),
              FillInBlank(
                  text: "Address",
                  hint: "Your Address",
                  icon: Iconsax.location),
              SizedBox(height: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    _requestLocationPermission();
                    // _getCurrentLocation().then((value){
                    //   lat = '${value.latitude}';
                    //   long = '${value.longitude}';
                    //   setState(() {
                    //     locationMessage = "Latitude: $lat, Longtitude: $long";
                    //   });
                    // });
                  },
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.map),
                        SizedBox(width: 8),
                        Text("Get current location",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text("Latitud: ${_locationData?.latitude?? ""}"),
              Text("Longtitud: ${_locationData?.longitude?? ""}"),

              SizedBox(height: 16),
              Container(
                height: 300,
                width: 500,
                color: primary,
                child: Text("Map"),
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
