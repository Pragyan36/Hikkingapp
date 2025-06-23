import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _drawMode = false;

  //Arrow in route
  List<Marker> _buildDirectionArrows() {
    List<Marker> arrows = [];
    for (int i = 0; i < _route.length - 1; i += 10) {
      final start = _route[i];
      final end = _route[i + 1];
      final angle =
          _calculateBearing(start, end) * (math.pi / 180); // in radians

      arrows.add(
        Marker(
          point: start,
          width: 30,
          height: 30,
          child: Transform.rotate(
            angle: angle,
            child: const Icon(Icons.navigation, color: Colors.blue, size: 30),
          ),
        ),
      );
    }
    return arrows;
  }

  double _calculateBearing(latlong.LatLng start, latlong.LatLng end) {
    final lat1 = start.latitude * (math.pi / 180);
    final lat2 = end.latitude * (math.pi / 180);
    final dLon = (end.longitude - start.longitude) * (math.pi / 180);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * (180 / math.pi) + 360) % 360;
  }

  final MapController _mapController = MapController();
  latlong.LatLng? _currentPosition;
  bool _mapReady = false;
  final Location _location = Location();
  final TextEditingController _locationcontroller = TextEditingController();
  latlong.LatLng? _destination;
  List<latlong.LatLng> _route = [];
  bool _snackShown = false;
  String? _distance;
  String? _duration;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<bool> _checkPermissionAndService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<void> _initLocation() async {
    if (!await _checkPermissionAndService()) return;

    try {
      final currentLocation = await _location.getLocation();

      setState(() {
        _currentPosition = (currentLocation.latitude != null &&
                currentLocation.longitude != null)
            ? latlong.LatLng(
                currentLocation.latitude!, currentLocation.longitude!)
            : null;
      });

      if (_currentPosition == null && !_snackShown && mounted) {
        _snackShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Current location not available.")),
        );
      }

      if (_mapReady && _currentPosition != null) {
        _mapController.move(_currentPosition!, 15);
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _fetchCoordinatesPoint(String location) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1",
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'FlutterApp/1.0 (your_email@example.com)',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        final latLng = latlong.LatLng(lat, lon);

        setState(() {
          _destination = latLng;
        });
        await _fetchRoute();

        if (_mapReady) {
          _mapController.move(latLng, 15);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location not found")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch location")),
      );
    }
  }

  String _travelMode =
      "driving"; // or "foot" if using your own OSRM server for walking

  Future<void> _fetchRoute() async {
    if (_currentPosition == null || _destination == null) return;

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/$_travelMode/'
      '${_currentPosition!.longitude},${_currentPosition!.latitude};'
      '${_destination!.longitude},${_destination!.latitude}?geometries=geojson&overview=full',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      final distance = data['routes'][0]['distance'];
      final duration = data['routes'][0]['duration'];

      setState(() {
        _route =
            coords.map((point) => latlong.LatLng(point[1], point[0])).toList();
        _distance = (distance / 1000).toStringAsFixed(2);
        _duration = (duration / 60).toStringAsFixed(1);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch route")),
      );
    }
  }

  // Future<void> _fetchRoute() async {
  //   if (_currentPosition == null || _destination == null) return;

  //   final url = Uri.parse(
  //     'http://router.project-osrm.org/route/v1/driving/'
  //     '${_currentPosition!.longitude},${_currentPosition!.latitude};'
  //     '${_destination!.longitude},${_destination!.latitude}?geometries=geojson&overview=full',
  //   );

  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final coords = data['routes'][0]['geometry']['coordinates'] as List;
  //     final distance = data['routes'][0]['distance'];
  //     final duration = data['routes'][0]['duration'];

  //     setState(() {
  //       _route =
  //           coords.map((point) => latlong.LatLng(point[1], point[0])).toList();
  //       _distance = (distance / 1000).toStringAsFixed(2);
  //       _duration = (duration / 60).toStringAsFixed(1);
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to fetch route")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onMapReady: () {
              _mapReady = true;
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, 15);
              }
            },
            onTap: (tapPosition, latlng) {
              if (_drawMode) {
                setState(() {
                  _route.add(latlng);
                });
              }
            },
            initialCenter: _currentPosition ?? latlong.LatLng(27.7172, 85.3240),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            if (_route.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _route,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (_currentPosition != null)
                  Marker(
                    point: _currentPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on,
                        color: Colors.blue, size: 40),
                  ),
                if (_destination != null)
                  Marker(
                    point: _destination!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 40),
                  ),
                ..._buildDirectionArrows(),
              ],
            ),
          ],
        ),

        // Search bar
        Positioned(
          top: 40,
          left: 20,
          right: 70,
          child: TextField(
            controller: _locationcontroller,
            decoration: InputDecoration(
              filled: true,
              hintText: "Enter a location",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  final location = _locationcontroller.text.trim();
                  if (location.isNotEmpty) {
                    _fetchCoordinatesPoint(location);
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 160,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _travelMode = "driving";
                      _route.clear();
                      _distance = null;
                      _duration = null;
                    });
                    if (_destination != null) _fetchRoute();
                  },
                  child: const Text("Driving"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _travelMode =
                          "foot"; // NOTE: OSRM public server does not support "foot"
                      _route.clear();
                      _distance = null;
                      _duration = null;
                    });
                    if (_destination != null) _fetchRoute();
                  },
                  child: const Text("Walking"),
                ),
              ],
            ),
          ),
        ),

        // Positioned(
        //   top: 100,
        //   left: 20,
        //   right: 20,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //     child: SwitchListTile(
        //       title: const Text("Draw My Own Trail"),
        //       value: _drawMode,
        //       onChanged: (value) {
        //         setState(() {
        //           _drawMode = value;
        //           _route.clear();
        //           _distance = null;
        //           _duration = null;
        //         });
        //       },
        //     ),
        //   ),
        // ),

        // Distance & Duration display
        if (_distance != null && _duration != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Distance: $_distance km | Duration: $_duration min",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ]),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom + 1);
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom - 1);
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "location",
            onPressed: () {
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, 15);
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
