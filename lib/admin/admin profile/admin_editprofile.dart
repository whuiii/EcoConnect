import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:navigate/color.dart'; // ✅ your centralized colors
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:quickalert/quickalert.dart';

// ✅ No local const button! Use `button` from color.dart

Future<Uint8List> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
  throw Exception('No image selected');
}

class AdminEditProfile extends StatefulWidget {
  const AdminEditProfile({super.key});

  @override
  State<AdminEditProfile> createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  Uint8List? _image;
  String? existingImageUrl;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(text: "********");

  final GlobalKey<LocationPickerMapState> _mapKey =
      GlobalKey<LocationPickerMapState>();
  LatLng companyLocation = const LatLng(3.1319, 101.6841);

  @override
  void initState() {
    super.initState();
    loadCompanyData();
  }

  Future<void> loadCompanyData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _companyNameController.text = data['companyName'] ?? '';
        _regNumberController.text = data['registrationNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        existingImageUrl = data['companyLogo'];

        double lat = data['latitude'] ?? 3.1319;
        double lng = data['longitude'] ?? 101.6841;
        companyLocation = LatLng(lat, lng);

        setState(() {});
      }
    } catch (e) {
      debugPrint("Error loading company data: $e");
    }
  }

  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (_) {
      debugPrint("Image pick canceled");
    }
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not signed in');

    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('companyLogos')
        .child('$uid.jpg');

    final uploadTask = ref.putData(image);
    final snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  void _searchAndNavigate(String address) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final locResult = locations.first;
        LatLng searched = LatLng(locResult.latitude, locResult.longitude);
        _mapKey.currentState?.moveToLocation(searched);
        setState(() => companyLocation = searched);
      }
    } catch (e) {
      debugPrint("Address search failed: $e");
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
    LatLng newLocation =
        LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    _mapKey.currentState?.moveToLocation(newLocation);
  }

  void _showChangePasswordDialog() {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final current = currentPassCtrl.text.trim();
              final newPass = newPassCtrl.text.trim();
              final confirm = confirmPassCtrl.text.trim();

              if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "All fields are required.",
                );
                return;
              }
              if (newPass != confirm) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "New passwords do not match.",
                );
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) throw Exception("No user signed in.");

                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: current,
                );

                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPass);

                Navigator.pop(context);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: "Password updated successfully!",
                  onConfirmBtnTap: () {
                    Navigator.pop(context); // Dismiss alert
                    Navigator.pop(context); // Go back to previous screen
                  },
                );
              } catch (e) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "Failed: ${e.toString()}",
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void saveProfileChanges() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String? imageUrl;
    if (_image != null) {
      imageUrl = await uploadImageToStorage(_image!);
    }

    final dataToUpdate = {
      'email': _emailController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'latitude': companyLocation.latitude,
      'longitude': companyLocation.longitude,
    };

    if (imageUrl != null) {
      dataToUpdate['companyLogo'] = imageUrl;
    }

    await FirebaseFirestore.instance
        .collection('companies')
        .doc(uid)
        .update(dataToUpdate);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: "Profile updated successfully!",
      onConfirmBtnTap: () {
        Navigator.pop(context); // Dismiss alert
        Navigator.pop(context, true);  // Go back to previous screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Company Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? MemoryImage(_image!)
                      : (existingImageUrl != null &&
                              existingImageUrl!.isNotEmpty)
                          ? NetworkImage(existingImageUrl!)
                          : const AssetImage(
                                  'assets/images/EcoConnect_Logo.png')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: selectImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
                _companyNameController, "Company Name", Iconsax.building,
                readOnly: true),
            _buildTextField(
                _regNumberController, "Registration Number", Iconsax.document,
                readOnly: true),
            _buildTextField(_emailController, "Email", Iconsax.sms),
            _buildTextField(_phoneController, "Phone Number", Iconsax.call),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Address",
                prefixIcon: const Icon(Iconsax.location),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          _searchAndNavigate(_addressController.text),
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: _getCurrentLocation,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            LocationPickerMap(
              key: _mapKey,
              initialLocation: companyLocation,
              onLocationChanged: (latLng) => companyLocation = latLng,
              onAddressChanged: (address) => _addressController.text = address,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              readOnly: true,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Change Password",
                prefixIcon: const Icon(Iconsax.key),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _showChangePasswordDialog,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: button),
                child: const Text("Save Changes",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title: "Confirm",
                    text: "Save profile changes?",
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                      saveProfileChanges();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl, String label, IconData icon,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

// ✅ Map widget stays the same
class LocationPickerMap extends StatefulWidget {
  final LatLng initialLocation;
  final ValueChanged<LatLng> onLocationChanged;
  final ValueChanged<String> onAddressChanged;

  const LocationPickerMap({
    super.key,
    required this.initialLocation,
    required this.onLocationChanged,
    required this.onAddressChanged,
  });

  @override
  LocationPickerMapState createState() => LocationPickerMapState();
}

class LocationPickerMapState extends State<LocationPickerMap> {
  late GoogleMapController _controller;
  late LatLng _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _addMarker(_currentLocation);
  }

  void moveToLocation(LatLng newLocation) {
    setState(() {
      _currentLocation = newLocation;
      _addMarker(newLocation);
    });
    _controller.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 16));
    widget.onLocationChanged(newLocation);
    _getAddress(newLocation);
  }

  void _addMarker(LatLng pos) {
    _markers = {
      Marker(markerId: const MarkerId('picked'), position: pos),
    };
  }

  Future<void> _getAddress(LatLng pos) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
            "${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
        widget.onAddressChanged(address);
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _currentLocation, zoom: 16),
        onMapCreated: (controller) {
          _controller = controller;
        },
        markers: _markers,
        myLocationEnabled: true,
        onTap: moveToLocation,
      ),
    );
  }
}
