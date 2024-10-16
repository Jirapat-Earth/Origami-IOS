import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationGoogleMap extends StatefulWidget {
  const LocationGoogleMap({super.key, required this.latLng});
  final Function(LatLng?) latLng;
  @override
  _LocationGoogleMapState createState() => _LocationGoogleMapState();
}

class _LocationGoogleMapState extends State<LocationGoogleMap> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แตะเพื่อเลือกตำแหน่ง'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location; // เก็บตำแหน่งที่ผู้ใช้แตะ
                widget.latLng(location);
              });
              Navigator.pop(context);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(13.7563, 100.5018), // ค่าเริ่มต้น: กรุงเทพ
              zoom: 10,
            ),
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation!,
              ),
            }
                : {},
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 50,
              left: 20,
              child: Text(
                'ตำแหน่งที่เลือก: \nLat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
