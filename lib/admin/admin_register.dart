import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigate/admin/admin%20services/admin_service.dart';
import 'package:navigate/admin/admin_login.dart';
import 'package:navigate/utilis.dart';

import '../color.dart';

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    if (!mounted) return;
    setState(() {
      _image = img;
    });
  }

  final GlobalKey<_LocationPickerMapState> _mapKey = GlobalKey<_LocationPickerMapState>();

  Future<String> uploadImageToStorage(Uint8List image) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('companyLogos')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.UploadTask uploadTask = ref.putData(image);
    firebase_storage.TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  bool securePassword = true;
  bool? isChecked = false;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  LatLng companyLocation = LatLng(3.1319, 101.6841);
  String companyAddress = "";

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
    });
  }

  final companyService = AdminService();

  void handleAdminRegister() async {
    if (isChecked != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please accept Terms & Privacy Policy")),
      );
      return;
    }

    try {
      String logoUrl = '';
      if (_image != null) {
        logoUrl = await uploadImageToStorage(_image!);
      }

      print("About to register with:");
      print("Lat: ${companyLocation.latitude}, Lng: ${companyLocation.longitude}");

      String? result = await companyService.registerAdminCompany(
        companyLogo: logoUrl,
        companyName: companyNameController.text.trim(),
        registrationNumber: registrationNumberController.text.trim(),
        address: addressController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        latitude: companyLocation.latitude,
        longitude: companyLocation.longitude,
      );

      if (!mounted) return;

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _searchAndNavigate(String address) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final locResult = locations.first;
        LatLng searchedLatLng = LatLng(locResult.latitude, locResult.longitude);

        // Tell the map to move!
        _mapKey.currentState?.moveToLocation(searchedLatLng);

        if (!mounted) return;
        setState(() {
          companyLocation = searchedLatLng;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location found and updated on map!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address not found")),
      );
    }
  }

  void _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    loc.LocationData locationData = await location.getLocation();
    LatLng newLocation = LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);

    _mapKey.currentState?.moveToLocation(newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),
                FadeInUp(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(radius: 60, backgroundImage: MemoryImage(_image!))
                          : CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/EcoConnect_Logo.png'),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade300,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo, size: 18),
                            color: Colors.black,
                            onPressed: selectImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                FadeInUp(
                  child: Text("Welcome Waste Company",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                ),
                SizedBox(height: 5),
                FadeInUp(
                  child: Text("Register to EcoConnect",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ),
                SizedBox(height: 30),

                FadeInUp(
                  child: TextField(
                    controller: companyNameController,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Company Name", Iconsax.building),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  child: TextField(
                    controller: registrationNumberController,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Business Reg. No.in SSM", Iconsax.document),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  child: TextField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Company Email", Iconsax.sms),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  child: TextField(
                    controller: phoneController,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Company Phone", Iconsax.call),
                  ),
                ),
                SizedBox(height: 20),

                FadeInUp(
                  child: TextField(
                    controller: addressController,
                    cursorColor: Colors.black,
                    maxLines: 2,
                    decoration: inputDecoration("Company Address", Iconsax.location).copyWith(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.search, size: 20),
                            onPressed: () => _searchAndNavigate(addressController.text),
                          ),
                          IconButton(
                            icon: Icon(Icons.my_location, size: 20),
                            onPressed: _getCurrentLocation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                LocationPickerMap(
                  key: _mapKey,
                  initialLocation: companyLocation,
                  onLocationChanged: (LatLng newLatLng) {
                    companyLocation = newLatLng;
                  },
                  onAddressChanged: (String address) {
                    addressController.text = address;
                  },
                ),

                SizedBox(height: 20),

                FadeInUp(
                  child: TextField(
                    controller: passwordController,
                    onChanged: onPasswordChanged,
                    obscureText: securePassword,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Password", Iconsax.key).copyWith(
                      suffixIcon: togglePassword(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Row(
                    children: [
                      passwordRequirementCheck(_isPasswordEightCharacters, "At least 8 characters"),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Row(
                    children: [
                      passwordRequirementCheck(_hasPasswordOneNumber, "At least 1 number"),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                FadeInUp(
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: securePassword,
                    cursorColor: Colors.black,
                    decoration: inputDecoration("Confirm Password", Iconsax.lock).copyWith(
                      suffixIcon: togglePassword(),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                FadeInUp(
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) => setState(() => isChecked = val),
                      ),
                      Text("I agree to the Terms & Privacy Policy")
                    ],
                  ),
                ),
                FadeInUp(
                  child: MaterialButton(
                    onPressed: handleAdminRegister,
                    height: 45,
                    minWidth: double.infinity,
                    color: button,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Text("SIGN UP",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Get.to(AdminLoginPage());
                        },
                        child: Text("Login", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon, color: Colors.black, size: 18),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget passwordRequirementCheck(bool condition, String text) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: condition ? Colors.green : Colors.transparent,
            border: Border.all(color: condition ? Colors.transparent : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: condition ? Icon(Icons.check, color: Colors.white, size: 15) : SizedBox(),
        ),
        SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () => setState(() => securePassword = !securePassword),
      icon: Icon(securePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
    );
  }
}

class LocationPickerMap extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng) onLocationChanged;
  final Function(String) onAddressChanged;

  const LocationPickerMap({
    super.key,
    required this.initialLocation,
    required this.onLocationChanged,
    required this.onAddressChanged,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late LatLng _currentLocation;
  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _addMarker(_currentLocation);
  }

  void moveToLocation(LatLng newLatLng) {
    _currentLocation = newLatLng;

    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(newLatLng, 16),
    );

    _addMarker(newLatLng);
    _getAddressFromLatLng(newLatLng);

    widget.onLocationChanged(newLatLng);
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("pickedLocation"),
          position: position,
        ),
      );
    });
    print("New Camera Position: Lat: ${_currentLocation.latitude}, Lng: ${_currentLocation.longitude}");
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<geo.Placemark> placemarks =
      await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks.first;
        String address =
            "${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

        widget.onAddressChanged(address);
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 16),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _googleMapController = controller;
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentLocation, zoom: 16),
            ),
          );
        },
        onCameraMove: (position) {
          _currentLocation = position.target;
          widget.onLocationChanged(_currentLocation);
          print("New Camera Position: Lat: ${_currentLocation.latitude}, Lng: ${_currentLocation.longitude}");
        },
        onCameraIdle: () {
          _getAddressFromLatLng(_currentLocation);
        },
        onTap: (position) {
          _currentLocation = position;
          widget.onLocationChanged(_currentLocation);
          _addMarker(position);
          _getAddressFromLatLng(position);
        },
      ),
    );
  }
}
