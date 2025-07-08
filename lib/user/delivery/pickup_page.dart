import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:navigate/color.dart';
import 'package:navigate/services/delivery_service.dart';
import 'package:navigate/user/delivery/bagsize_roundcheck.dart';
import 'package:navigate/user/delivery/dateTimePicker.dart';
import 'package:navigate/user/delivery/placeholder_address.dart';
import 'package:navigate/user/delivery/placeholder_delivery.dart';
import 'package:navigate/menu.dart';

class PickUpForm extends StatefulWidget {
  const PickUpForm({super.key});

  @override
  State<PickUpForm> createState() => _PickUpFormState();
}

class _PickUpFormState extends State<PickUpForm> {
  //Enable GPS Location
  loc.Location location = loc.Location();
  bool _serviceEnabled = false;
  loc.PermissionStatus? _permissionGranted;
  loc.LocationData? _locationData;
  late GoogleMapController googleMapController;
  Set<Marker> marker = {};
  String? deliveryOption;

  final _formKey = GlobalKey<FormState>();

  //Collect Account (Step 1)
  bool _loadingUser = true;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final _searchController = TextEditingController();

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
  final remarkController = TextEditingController();

  //Get Company List (Step 3)
  List<Map<String, dynamic>> _companies = [];
  String? _selectedCompanyUid;
  Map<String, double> _companyDistances = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location when widget is initialized
    _loadUserData();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    _searchController.dispose();
    remarkController.dispose();
    googleMapController.dispose();
    super.dispose();
  }

//Load User Name, Email and Phone
  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        emailController.text = data['email'] ?? '';
        usernameController.text = data['username'] ?? '';
        phoneController.text = data['phone'] ?? '';
        _loadingUser = false;
      });
    } else {
      setState(() {
        _loadingUser = false;
      });
    }
  }

  //Load Company List and Distance
  Future<void> _loadCompanies() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('companies').get();
    setState(() {
      _companies = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (var company in _companies) {
        print('Loaded company: ${company['companyName']}');

        final double distance = Geolocator.distanceBetween(
          myCurrentLocation.latitude,
          myCurrentLocation.longitude,
          company['latitude'],
          company['longitude'],
        );

        _companyDistances[company['uid']] = distance / 1000.0;
      }

      if (_companies.isNotEmpty) {
        _selectedCompanyUid = _companies.first['uid'];
      }
    });
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

      if (!mounted) return;
      setState(() {
        myCurrentLocation = newLocation;
      });

      await _getAddressFromLatLng(newLocation);

      // Move camera to current location
      if (googleMapController != null) {
        googleMapController!.animateCamera(
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
      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks.first;
        setState(() {
          currentAddress =
              "${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
          _searchController.text = currentAddress; //Update the TextField
        });
      }
    } catch (e) {
      if (!mounted) return;
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

        if (!mounted) return;
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
      if (!mounted) return;
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

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _saveDelivery() async {
    List<String> materials = [];
    if (isPlastic == true) materials.add('Plastic');
    if (isAluminium == true) materials.add('Aluminium');
    if (isPaper == true) materials.add('Paper');

    try {
      await DeliveryService().createDelivery(
        userId: FirebaseAuth.instance.currentUser!.uid, // <-- add this
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        materials: materials,
        bagSize: selectedBagSize,
        date: selectedDate!,
        time: formatTimeOfDay(selectedTime!),
        address: currentAddress,
        latitude: myCurrentLocation.latitude,
        longitude: myCurrentLocation.longitude,
        remark: remarkController.text,
        status: "Pending",
        companyUid: _selectedCompanyUid!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery successfully saved!')));
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save delivery')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick-Up")),
      body: Container(
        child: Column(
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
                    onPressed: () async {
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
                        await _loadCompanies();
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
                    text: emailController.text,
                    isEnabled: false,
                    hint: "Email",
                    icon: Iconsax.sms,
                    controller: emailController,
                    showLabel: false),
                SizedBox(height: 16),
                FillInBlank(
                    text: usernameController.text,
                    isEnabled: false,
                    hint: "Username",
                    icon: Iconsax.user,
                    controller: usernameController,
                    showLabel: false),
                SizedBox(height: 16),
                FillInBlank(
                    text: phoneController.text,
                    isEnabled: false,
                    hint: "Phone Number",
                    icon: Iconsax.call,
                    controller: phoneController,
                    showLabel: false),
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
                  prefixIcon: Icon(Iconsax.location),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchAndNavigate(_searchController.text),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Light background like a form field
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    // 👈 Match enabled border
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 10),
              FillInBlank(
                text: "Remarks",
                controller: remarkController,
                icon: Iconsax.edit,
                hint: "Remarks",
                isEnabled: true,
                showLabel: false,
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
                child: _map(),
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text("Complete"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 10),
              const Text(
                "All steps completed!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const LabelText(text: "Select a Company:"),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedCompanyUid,
                items: _companies.map((company) {
                  final distance = _companyDistances[company['uid']] ?? 0.0;
                  return DropdownMenuItem<String>(
                    value: company['uid'],
                    child: SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                company['companyName'] ?? 'Unnamed Company',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${distance.toStringAsFixed(2)} km",
                              style: TextStyle(
                                  fontSize: 9, color: Colors.grey[600]),
                            ),
                          ],
                        )),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompanyUid = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedCompanyUid != null)
                Builder(builder: (context) {
                  final selectedCompany = _companies.firstWhere(
                    (company) => company['uid'] == _selectedCompanyUid,
                    orElse: () => {},
                  );
                  if (selectedCompany.isEmpty) {
                    return const Text("Company details not available");
                  }
                  return Column(
                    children: [
                      FillInBlank(
                        text: selectedCompany['companyName'] ?? '',
                        icon: Iconsax.building,
                        hint: "Company Name",
                        showLabel: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 10),
                      FillInBlank(
                        text: selectedCompany['email'] ?? '',
                        icon: Icons.email,
                        hint: "Company Email",
                        showLabel: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 10),
                      FillInBlank(
                        text: selectedCompany['phone'] ?? '',
                        icon: Iconsax.call,
                        hint: "Company Phone",
                        showLabel: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 10),
                      AddressPlaceholder(
                          selectedCompany:
                              selectedCompany['address'] ?? 'no valid address')
                    ],
                  );
                }),
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

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Text(text,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }
}
