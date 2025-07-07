import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:navigate/color.dart';

class DropOffCenters extends StatefulWidget {
  const DropOffCenters({super.key});

  @override
  State<DropOffCenters> createState() => _DropOffCentersState();
}

class _DropOffCentersState extends State<DropOffCenters> {
  final TextEditingController _searchController = TextEditingController();
  LatLng myCurrentLocation = LatLng(3.1319, 101.6841);
  Set<Marker> marker = {};
  GoogleMapController? googleMapController;

  List<Map<String, dynamic>> _companies = [];
  Map<String, double> _companyDistances = {};
  int currentStep = 0;

  String? selectedCompanyId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    myCurrentLocation = LatLng(position.latitude, position.longitude);

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      String address =
          "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}";
      _searchController.text = address;
    }

    setState(() {});
  }

  Future<void> _loadCompanies() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('companies').get();
    setState(() {
      _companies = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (var company in _companies) {
        final double distance = Geolocator.distanceBetween(
          myCurrentLocation.latitude,
          myCurrentLocation.longitude,
          company['latitude'],
          company['longitude'],
        );
        _companyDistances[company['uid']] = distance / 1000.0;
      }
    });
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

        await googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: searchedLatLng, zoom: 16),
          ),
        );
      }
    } catch (e) {
      print("Search failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drop-Off Centers")),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep -= 1);
          }
        },
        onStepContinue: () async {
          if (currentStep == 0) {
            if (_searchController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter your address.")),
              );
              return;
            }

            await _searchAndNavigate(_searchController.text);
            await _loadCompanies();
            setState(() => currentStep += 1);
          } else if (currentStep == 1) {
            if (selectedCompanyId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Please select a drop-off center.")),
              );
              return;
            }

            final selectedCompany = _companies.firstWhere(
              (company) => company['uid'] == selectedCompanyId,
              orElse: () => {},
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "You selected: ${selectedCompany['companyName'] ?? 'Unknown'}"),
              ),
            );

            // You can navigate to another screen or perform an action here if needed
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: currentStep > 0 ? details.onStepCancel : null,
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green2,
                    ),
                    onPressed: details.onStepContinue,
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          );
        },
        steps: [
          Step(
            isActive: currentStep >= 0,
            title: const Text("Location"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Your Address",
                    prefixIcon: const Icon(Iconsax.location),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          _searchAndNavigate(_searchController.text),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),

                const SizedBox(height: 8),

                // 👇 Add this: Get My Current Location Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text("Get current location",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    onPressed: () async {
                      await _getUserLocation();
                      marker.clear();
                      marker.add(
                        Marker(
                          markerId: const MarkerId("myLocation"),
                          position: myCurrentLocation,
                          infoWindow: const InfoWindow(title: "My Location"),
                        ),
                      );
                      await googleMapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: myCurrentLocation, zoom: 16),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: myCurrentLocation,
                      zoom: 16,
                    ),
                    markers: marker,
                    onMapCreated: (controller) =>
                        googleMapController = controller,
                  ),
                ),
              ],
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text("Centers"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Nearby Drop-off Centers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _companies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final company = _companies[index];
                    final distance = _companyDistances[company['uid']] ?? 0.0;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: selectedCompanyId == company['uid']
                          ? Colors.teal.shade100
                          : Colors.white, // change color if selected
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: selectedCompanyId == company['uid']
                              ? Colors.teal
                              : Colors.grey.shade300,
                          child: Icon(Iconsax.location,
                              color: selectedCompanyId == company['uid']
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        title: Text(
                          company['companyName'] ?? 'Unnamed Company',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              company['address'] ?? 'No Address',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${distance.toStringAsFixed(2)} km away",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedCompanyId = company['uid'];
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
