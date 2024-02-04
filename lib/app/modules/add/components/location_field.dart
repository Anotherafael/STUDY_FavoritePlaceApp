import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:study_favorite_places_app/app/models/place_location.dart';
import 'package:study_favorite_places_app/app/core/providers/place_location_provider.dart';

import '../../map/map.dart';

class LocationFieldWidget extends ConsumerStatefulWidget {
  const LocationFieldWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationFieldWidgetState();
}

class _LocationFieldWidgetState extends ConsumerState<LocationFieldWidget> {
  bool isLoading = false;

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyD6yHhHX1erl_VH6Lx65HEtHqUDhysT0Kg');
    final res = await http.get(url);
    final resData = json.decode(res.body);
    final address = resData['results'][0]['formatted_address'];

    ref.read(placeLocation.notifier).state = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );

    setState(() {
      isLoading = false;
    });
  }

  String get locationImage {
    if (ref.read(placeLocation) == null) {
      return '';
    }
    final lat = ref.read(placeLocation)?.latitude;
    final lon = ref.read(placeLocation)?.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyD6yHhHX1erl_VH6Lx65HEtHqUDhysT0Kg';
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;

    if (lat == null || lon == null) {
      return;
    }

    _savePlace(lat, lon);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: isLoading
              ? const CircularProgressIndicator()
              : Container(
                  child: locationImage.isEmpty
                      ? Text(
                          'No location selected.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        )
                      : Image.network(
                          locationImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Choose from map'),
            ),
          ],
        )
      ],
    );
  }
}
