import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSearchWidget extends StatefulWidget {
  final Function(String description, double lat, double lng) onPlaceSelected;

  const LocationSearchWidget({super.key, required this.onPlaceSelected});

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _suggestions = [];

  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final String apiKey = 'YOUR_GOOGLE_API_KEY';
    final String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseURL?input=$input&key=$apiKey&components=country:my';

    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() => _suggestions = result['predictions']);
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    final String apiKey = 'YOUR_GOOGLE_API_KEY';
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final location = result['result']['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];
      final description = result['result']['formatted_address'];

      widget.onPlaceSelected(description, lat, lng);
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Search location",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => fetchSuggestions(value),
        ),
        if (_suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]['description']),
                onTap: () async {
                  final placeId = _suggestions[index]['place_id'];
                  await fetchPlaceDetails(placeId);
                  setState(() {
                    _suggestions.clear();
                    _controller.text = _suggestions[index]['description'];
                  });
                },
              );
            },
          ),
      ],
    );
  }
}
