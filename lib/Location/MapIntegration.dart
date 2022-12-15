import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController mapController;
  Set<Marker> markers = {};
  LatLng myLocation = const LatLng(27.7060698, 85.3299096);
  @override
  void initState() {
    markers.add(
      Marker(
        markerId: MarkerId(myLocation.toString()),
        position: myLocation,
        infoWindow: const InfoWindow(
          title: 'location',
          snippet: 'near by softwarica',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Location',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 245, 245, 247),
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: myLocation,
          zoom: 5,
        ),
        markers: markers, //markers to show on map
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
