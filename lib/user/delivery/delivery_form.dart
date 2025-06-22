import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:navigate/color.dart';
import 'package:navigate/services/delivery_service.dart';
import 'package:navigate/user/delivery/bagsize_roundcheck.dart';
import 'package:navigate/user/delivery/dateTimePicker.dart';
import 'package:navigate/user/delivery/delivery.dart';
import 'package:navigate/user/delivery/placeholder_delivery.dart';
import 'package:navigate/flash_message.dart';
import 'package:navigate/user/ranking.dart/page_ranking.dart';
import 'package:navigate/label_text.dart';
import 'package:navigate/menu.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  //Enable GPS Location
  loc.Location location = loc.Location();
  bool _serviceEnabled = false;
  loc.PermissionStatus? _permissionGranted;
  loc.LocationData? _locationData;
  late GoogleMapController googleMapController;
  Set<Marker> marker = {};

  final _formKey = GlobalKey<FormState>();

  //Collect Account (Step 1)
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  int currentStep = 0;
  bool? isPlastic = false;
  bool? isAluminium = false;
  bool? isPaper = false;
  String selectedBagSize = "Small";

  //Collect Detail (Step 2)
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String currentAddress = "";
  LatLng myCurrentLocation = LatLng(3.1319, 101.6841);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location when widget is initialized
  }

  Future<void> _requestLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    if (_locationData != null) {
      LatLng newLocation = LatLng(
        _locationData!.latitude ?? 0.0,
        _locationData!.longitude ?? 0.0,
      );

      setState(() {
        myCurrentLocation = newLocation;
      });

      await _getAddressFromLatLng(newLocation);

      // Move camera to current location
      if (googleMapController != null) {
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newLocation, zoom: 16),
          ),
        );

        marker.clear();
        marker.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: newLocation,
            infoWindow: const InfoWindow(title: "Your Location"),
          ),
        );
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks.first;
        setState(() {
          currentAddress =
              "${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
          _searchController.text = currentAddress; //Update the TextField
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = "Unable to retrieve address.";
      });
      print("Error getting address: $e");
    }
  }

  Future<void> _searchAndNavigate(String place) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(place);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        LatLng searchedLatLng = LatLng(loc.latitude, loc.longitude);

        setState(() {
          myCurrentLocation = searchedLatLng;
          marker.clear();
          marker.add(
            Marker(
              markerId: const MarkerId("searchedLocation"),
              position: searchedLatLng,
              infoWindow: const InfoWindow(title: "Searched Location"),
            ),
          );
        });

        // Optional: update address text
        await _getAddressFromLatLng(searchedLatLng);

        // Move camera
        await googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: searchedLatLng, zoom: 16),
          ),
        );
      }
    } catch (e) {
      print("Search failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not found")),
      );
    }
  }

  void _handleCameraIdle() async {
    await _getAddressFromLatLng(myCurrentLocation);
    setState(() {
      marker.clear();
      marker.add(
        Marker(
          markerId: const MarkerId("selectedLocation"),
          position: myCurrentLocation,
          infoWindow: const InfoWindow(title: "Selected Location"),
        ),
      );
    });
  }

  Future<void> _saveDelivery() async {
    List<String> materials = [];
    if (isPlastic == true) materials.add('plastic');
    if (isAluminium == true) materials.add('aluminium');
    if (isPaper == true) materials.add('paper');

    try {
      await DeliveryService().createDelivery(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        materials: materials,
        bagSize: selectedBagSize,
        date: selectedDate!,
        time: selectedTime!,
        address: currentAddress,
        latitude: myCurrentLocation.latitude,
        longitude: myCurrentLocation.longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery successfully saved!')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save delivery')));
    }
  }

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
                controlsBuilder: (context, _) => SizedBox.shrink(),
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

                      if (currentStep == 0) {
                        // Perform validation only on first step
                        if (emailController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Please fill in your information')),
                          );
                          return;
                        }

                        if (!(isPlastic == true ||
                            isAluminium == true ||
                            isPaper == true)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please select at least one recyclable material')),
                          );
                          return;
                        }

                        if (selectedBagSize == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Please select estimated quantity')),
                          );
                          return;
                        }
                      }

                      if (currentStep == 1) {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select date and time')));
                          return;
                        }

                        if (myCurrentLocation.latitude == 3.1319 &&
                            myCurrentLocation.longitude == 101.6841) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please select your address or update location')),
                          );
                          return;
                        }

                        if (currentAddress.isEmpty ||
                            currentAddress == "Unable to retrieve address.") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Unable to get address. Please search or select location.')),
                          );
                          return;
                        }
                      }
                      if (isLastStep) {
                        // Final submit
                        _saveDelivery();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProviderPage(initialPage: 1)),
                        );
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
          content: Form(
            key: _formKey, // wrap whole form
            child: Column(
              children: [
                FillInBlank(
                  text: "Email",
                  isEnabled: true,
                  hint: "Email",
                  icon: Iconsax.sms,
                  controller: emailController,
                ),
                SizedBox(height: 16),
                FillInBlank(
                  text: "Username",
                  isEnabled: true,
                  hint: "Username",
                  icon: Iconsax.user,
                  controller: usernameController,
                ),
                SizedBox(height: 16),
                FillInBlank(
                  text: "Phone Number",
                  hint: "Phone Number",
                  isEnabled: true,
                  icon: Iconsax.call,
                  controller: phoneController,
                ),
                LabelText(text: "Recyclable Materials:"),
                Column(
                  children: [
                    Row(children: [
                      Checkbox(
                        value: isPlastic,
                        onChanged: (value) => setState(() => isPlastic = value),
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                      ),
                      Text("Plastic", style: TextName),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: isAluminium,
                        onChanged: (value) =>
                            setState(() => isAluminium = value),
                        activeColor: Colors.brown,
                        checkColor: Colors.white,
                      ),
                      Text("Aluminium", style: TextName),
                    ]),
                    Row(children: [
                      Checkbox(
                        value: isPaper,
                        onChanged: (value) => setState(() => isPaper = value),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                      ),
                      Text("Paper", style: TextName),
                    ]),
                  ],
                ),
                LabelText(text: "Estimated Quantity:"),
                BagSizeSelector(
                  selectedSize: selectedBagSize,
                  onChanged: (value) {
                    setState(() {
                      selectedBagSize = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: Text("Detail"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Get the Date and Time
              DateTimePickerWidget(
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Your Address",
                  labelText: currentAddress,
                  prefixIcon: Icon(Iconsax.location),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchAndNavigate(_searchController.text),
                  ),
                  filled: true,
                  fillColor:
                      Colors.grey[100], // Light background like a form field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _requestLocationPermission();
                      googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: myCurrentLocation, zoom: 16)),
                      );
                      setState(() {
                        marker.clear();
                        marker.add(
                          Marker(
                            markerId: const MarkerId("currentLocation"),
                            position: myCurrentLocation,
                            infoWindow: const InfoWindow(title: "You are here"),
                          ),
                        );
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.map),
                        SizedBox(width: 8),
                        Text("Get current location",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Container(
                height: 300,
                width: double.infinity,
                color: primary,
                child: _map(),
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text("Complete"),
          content: Column(
            children: [
              if (currentStep == 2) FlashMessage(),
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 10),
              Text("All steps completed!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              LabelText(text: "Company Name:"),
              FillInBlank(
                  text: "Sun Soon Yik Sdn Bhd",
                  icon: Iconsax.building,
                  hint: "Company Details",
                  isEnabled: false),
              SizedBox(height: 10),
              LabelText(text: "Driver Name:"),
              FillInBlank(
                  text: "Yusuf Taiyoob",
                  icon: Iconsax.user,
                  hint: "Driver Name",
                  isEnabled: false),
              SizedBox(height: 10),
              LabelText(text: "Driver Contact No:"),
              FillInBlank(
                  text: "0118885555",
                  icon: Iconsax.call,
                  hint: "Driver Contact",
                  isEnabled: false),
            ],
          ),
        ),
      ];

  Widget _map() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller) async {
        googleMapController = controller;

        // Delay slightly to ensure controller is ready
        await Future.delayed(const Duration(milliseconds: 300));

        // Move camera to current location
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: myCurrentLocation, zoom: 16),
          ),
        );

        // Add marker at current location
        setState(() {
          marker.clear();
          marker.add(
            Marker(
              markerId: const MarkerId("currentLocation"),
              position: myCurrentLocation,
              infoWindow: const InfoWindow(title: "Your Location"),
            ),
          );
        });
      },
      initialCameraPosition: CameraPosition(
        target: myCurrentLocation,
        zoom: 16,
      ),
      onCameraMove: (CameraPosition position) {
        setState(() {
          myCurrentLocation = position.target;
        });
      },
      onCameraIdle: _handleCameraIdle,
      onTap: (LatLng tappedPoint) async {
        setState(() {
          myCurrentLocation = tappedPoint;
        });

        await _getAddressFromLatLng(tappedPoint);

        setState(() {
          marker.clear();
          marker.add(
            Marker(
              markerId: const MarkerId("tappedLocation"),
              position: tappedPoint,
              infoWindow: const InfoWindow(title: "Selected Location"),
            ),
          );
        });
      },
      markers: marker,
    );
  }
}
