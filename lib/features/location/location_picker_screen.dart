import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerResult {
  final double lat;
  final double lng;
  final String address;
  final String pincode;
  final String area;

  LocationPickerResult({
    required this.lat,
    required this.lng,
    required this.address,
    required this.pincode,
    required this.area,
  });
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;

  LatLng? selectedLocation;

  String address = "Detecting your location...";
  String pincode = "";
  String area = "";

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // 📍 Get current GPS location
  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        address = "Please enable location services";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        address = "Location permission denied";
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    final pos = LatLng(position.latitude, position.longitude);

    setState(() {
      selectedLocation = pos;
      _updateMarker(pos);
    });

    await _getAddressFromLatLng(pos);

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(pos, 16),
    );
  }

  void _updateMarker(LatLng pos) {
    markers = {
      Marker(
        markerId: const MarkerId("selected"),
        position: pos,
      ),
    };
  }

  // 🏠 Convert lat/lng to address + pincode + area
  Future<void> _getAddressFromLatLng(LatLng pos) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        setState(() {
          area = p.locality ?? p.subAdministrativeArea ?? "";
          pincode = p.postalCode ?? "";

          address =
              "${p.name}, ${p.subLocality}, $area - $pincode";
        });
      }
    } catch (e) {
      setState(() {
        address = "Unable to fetch address";
      });
    }
  }

  void _onMapTap(LatLng pos) async {
    setState(() {
      selectedLocation = pos;
      _updateMarker(pos);
      address = "Fetching address...";
    });

    await _getAddressFromLatLng(pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: selectedLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) => mapController = controller,
                  markers: markers,
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),

                // 📍 Address Card
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),

                // ✅ Confirm Button
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        LocationPickerResult(
                          lat: selectedLocation!.latitude,
                          lng: selectedLocation!.longitude,
                          address: address,
                          pincode: pincode,
                          area: area,
                        ),
                      );
                    },
                    child: const Text("Confirm Location"),
                  ),
                ),
              ],
            ),
    );
  }
}
