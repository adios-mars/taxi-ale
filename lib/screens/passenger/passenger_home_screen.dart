import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Represents a transit terminal or landmark with bilingual names and GPS coordinates.
class AddisPlace {
  final String name;
  final String amharicName;
  final String subcity;
  final LatLng location;

  const AddisPlace({
    required this.name,
    required this.amharicName,
    required this.subcity,
    required this.location,
  });
}

/// In-memory registry of major Addis Ababa minibus hubs.
/// Pre-indexing common terminals gives zero-latency, offline-capable autocomplete
/// without making unnecessary round-trip network calls for common routes.
const List<AddisPlace> kAddisStations = [
  AddisPlace(name: 'Megenagna', amharicName: 'መገናኛ', subcity: 'Yeka', location: LatLng(9.0205, 38.8020)),
  AddisPlace(name: 'Mexico Square', amharicName: 'ሜክሲኮ', subcity: 'Kirkos', location: LatLng(9.0108, 38.7445)),
  AddisPlace(name: 'Bole Medhanialem', amharicName: 'ቦሌ መድኃኔዓለም', subcity: 'Bole', location: LatLng(8.9950, 38.7880)),
  AddisPlace(name: 'Piazza', amharicName: 'ፒያሳ', subcity: 'Arada', location: LatLng(9.0350, 38.7525)),
  AddisPlace(name: 'Torhailoch', amharicName: 'ጦር ኃይሎች', subcity: 'Kolfe Keranio', location: LatLng(9.0080, 38.7180)),
  AddisPlace(name: '4 Kilo (Arat Kilo)', amharicName: 'አራት ኪሎ', subcity: 'Arada', location: LatLng(9.0340, 38.7628)),
  AddisPlace(name: '6 Kilo (Sidist Kilo)', amharicName: 'ስድስት ኪሎ', subcity: 'Yeka', location: LatLng(9.0480, 38.7610)),
  AddisPlace(name: 'Merkato', amharicName: 'መርካቶ', subcity: 'Addis Ketema', location: LatLng(9.0300, 38.7380)),
  AddisPlace(name: 'Autobus Tera', amharicName: 'አውቶቡስ ተራ', subcity: 'Addis Ketema', location: LatLng(9.0380, 38.7320)),
  AddisPlace(name: 'Saris', amharicName: 'ሳሪስ', subcity: 'Nifas Silk', location: LatLng(8.9560, 38.7670)),
  AddisPlace(name: 'Gotera', amharicName: 'ጎተራ', subcity: 'Kirkos', location: LatLng(8.9880, 38.7560)),
  AddisPlace(name: 'Kera', amharicName: 'ቄራ', subcity: 'Kirkos', location: LatLng(8.9970, 38.7480)),
  AddisPlace(name: 'Sarbet', amharicName: 'ሳርቤት', subcity: 'Kirkos', location: LatLng(8.9990, 38.7320)),
  AddisPlace(name: 'Stadium', amharicName: 'ስታዲየም', subcity: 'Kirkos', location: LatLng(9.0130, 38.7580)),
  AddisPlace(name: 'Kazanchis', amharicName: 'ካዛንቺስ', subcity: 'Kirkos', location: LatLng(9.0190, 38.7720)),
  AddisPlace(name: 'Gerji (Imperial)', amharicName: 'ገርጂ', subcity: 'Bole', location: LatLng(8.9980, 38.8150)),
  AddisPlace(name: 'CMC', amharicName: 'ሲኤምሲ', subcity: 'Yeka', location: LatLng(9.0220, 38.8450)),
  AddisPlace(name: 'Ayat', amharicName: 'አያት', subcity: 'Yeka', location: LatLng(9.0240, 38.8750)),
  AddisPlace(name: 'Summit', amharicName: 'ሰሚት', subcity: 'Bole', location: LatLng(9.0180, 38.8650)),
  AddisPlace(name: 'Bole Bulbula', amharicName: 'ቦሌ ቡልቡላ', subcity: 'Bole', location: LatLng(8.9680, 38.7900)),
  AddisPlace(name: 'Bole Michael', amharicName: 'ቦሌ ሚካኤል', subcity: 'Bole', location: LatLng(8.9820, 38.7750)),
  AddisPlace(name: 'Jemo 1', amharicName: 'ጀምኦ', subcity: 'Nifas Silk', location: LatLng(8.9550, 38.7050)),
  AddisPlace(name: 'Lebu', amharicName: 'ለቡ', subcity: 'Nifas Silk', location: LatLng(8.9580, 38.7250)),
  AddisPlace(name: 'Shiromeda', amharicName: 'ሽሮሜዳ', subcity: 'Gullele', location: LatLng(9.0620, 38.7630)),
  AddisPlace(name: 'Shola Market', amharicName: 'ሾላ ገበያ', subcity: 'Yeka', location: LatLng(9.0230, 38.7870)),
  AddisPlace(name: 'Hayat Hospital', amharicName: 'ሀያት ሆስፒታል', subcity: 'Bole', location: LatLng(9.0060, 38.8000)),
  AddisPlace(name: 'Kality', amharicName: 'ቃሊቲ', subcity: 'Akaki Kality', location: LatLng(8.9100, 38.7560)),
  AddisPlace(name: 'Gofa Camp', amharicName: 'ጎፋ', subcity: 'Nifas Silk', location: LatLng(8.9820, 38.7420)),
  AddisPlace(name: 'Winget', amharicName: 'ዊንጌት', subcity: 'Kolfe Keranio', location: LatLng(9.0550, 38.7180)),
  AddisPlace(name: 'Addisu Gebeya', amharicName: 'አዲሱ ገበያ', subcity: 'Gullele', location: LatLng(9.0570, 38.7400)),
];

class PassengerHomeMapScreen extends StatefulWidget {
  const PassengerHomeMapScreen({super.key});

  @override
  State<PassengerHomeMapScreen> createState() => _PassengerHomeMapScreenState();
}

class _PassengerHomeMapScreenState extends State<PassengerHomeMapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _fromController = TextEditingController(text: 'My Current Location');
  final TextEditingController _toController = TextEditingController();
  final FocusNode _toFocusNode = FocusNode();

  // Initial center defaults to central Addis Ababa until GPS resolves
  LatLng _userLocation = const LatLng(9.0108, 38.7450);
  LatLng? _destinationPoint;
  String _destinationName = '';

  bool _isLocating = true;
  StreamSubscription<Position>? _positionStream;

  // Turn-by-turn road polyline points from OSRM
  List<LatLng> _routePoints = [];
  String _distanceKm = '';
  String _durationMins = '';

  // Approaching minibuses on nearby streets
  List<LatLng> _minibuses = [];

  // Predictive search state
  List<AddisPlace> _predictions = [];
  bool _showPredictions = false;
  bool _isSearchCardExpanded = true;
  Timer? _debounceTimer;

  // Curated quick-select chips for high-frequency commuter routes
  final List<String> _quickPlaces = [
    'Megenagna',
    'Mexico Square',
    'Bole Medhanialem',
    'Piazza',
    'Torhailoch',
    '4 Kilo (Arat Kilo)',
    'Saris',
    'Merkato',
  ];

  @override
  void initState() {
    super.initState();
    _locateAndCenterUser();

    _toFocusNode.addListener(() {
      if (_toFocusNode.hasFocus) {
        _filterPredictions(_toController.text);
        setState(() {
          _showPredictions = true;
          _isSearchCardExpanded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _positionStream?.cancel();
    _fromController.dispose();
    _toController.dispose();
    _toFocusNode.dispose();
    super.dispose();
  }

  // Debounced input handler to prevent flooding Nominatim when user types custom addresses
  void _onToTextChanged(String query) {
    _debounceTimer?.cancel();
    _filterPredictions(query);

    // If local matches are few and query length is sufficient, query OpenStreetMap Nominatim
    if (query.trim().length >= 3 && _predictions.length < 3) {
      _debounceTimer = Timer(const Duration(milliseconds: 600), () {
        _searchOnlineNominatim(query.trim());
      });
    }
  }

  void _filterPredictions(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _predictions = kAddisStations.take(6).toList();
      } else {
        _predictions = kAddisStations.where((place) {
          return place.name.toLowerCase().contains(q) ||
              place.amharicName.contains(q) ||
              place.subcity.toLowerCase().contains(q);
        }).toList();
      }
      _showPredictions = true;
    });
  }

  // Online search fallback bounded to Addis Ababa geographical bounding box
  Future<void> _searchOnlineNominatim(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}'
      '&format=json&limit=5&countrycodes=et&viewbox=38.65,9.10,38.90,8.85&bounded=1',
    );

    try {
      final response = await http.get(url, headers: {'User-Agent': 'TaxiAleApp/1.0'});
      if (response.statusCode == 200) {
        final List list = json.decode(response.body);
        final onlinePlaces = list.map((item) {
          final displayName = item['display_name'] as String;
          final parts = displayName.split(',');
          return AddisPlace(
            name: parts.first.trim(),
            amharicName: '',
            subcity: parts.length > 1 ? parts[1].trim() : 'Addis Ababa',
            location: LatLng(double.parse(item['lat']), double.parse(item['lon'])),
          );
        }).toList();

        if (mounted && onlinePlaces.isNotEmpty) {
          setState(() {
            final existingNames = _predictions.map((p) => p.name.toLowerCase()).toSet();
            for (var p in onlinePlaces) {
              if (!existingNames.contains(p.name.toLowerCase())) {
                _predictions.add(p);
              }
            }
          });
        }
      }
    } catch (_) {
      // Gracefully silent on transient connection drops
    }
  }

  // Compute straight-line geodesic distance in kilometers from current GPS coordinates
  String _calcDistance(LatLng target) {
    final meters = Geolocator.distanceBetween(
      _userLocation.latitude,
      _userLocation.longitude,
      target.latitude,
      target.longitude,
    );
    return (meters / 1000).toStringAsFixed(1);
  }

  // Handle destination selection from search autocomplete, quick chip, or map tap
  void _selectDestination(LatLng target, String displayName) {
    setState(() {
      _destinationPoint = target;
      _destinationName = displayName;
      _toController.text = displayName;
      _showPredictions = false;
      _predictions.clear();
      // Collapse the search inputs to keep the map and route clearly visible
      _isSearchCardExpanded = false;
    });

    // Dismiss keyboard immediately to open up map view
    _toFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    _fetchRoadRoute(_userLocation, target);
    _fitRouteOnMap(_userLocation, target);
  }

  // Dynamically pad the camera bounds so the destination pin remains visible above the trip card
  void _fitRouteOnMap(LatLng start, LatLng end) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final bounds = LatLngBounds.fromPoints([start, end]);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.only(
              top: 100, // Clearance for top transit info pill
              bottom: 180, // Clearance for bottom summary card
              left: 50,
              right: 50,
            ),
          ),
        );
      } catch (e) {
        final centerLat = (start.latitude + end.latitude) / 2;
        final centerLng = (start.longitude + end.longitude) / 2;
        _mapController.move(LatLng(centerLat, centerLng), 14.0);
      }
    });
  }

  // Two-phase location retrieval: instant cached position, then accurate satellite fix
  Future<void> _locateAndCenterUser() async {
    setState(() => _isLocating = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please turn on your device GPS location'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => Geolocator.openLocationSettings(),
            ),
          ),
        );
      }
      setState(() => _isLocating = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocating = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location permissions are permanently denied'),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () => Geolocator.openAppSettings(),
            ),
          ),
        );
      }
      setState(() => _isLocating = false);
      return;
    }

    // Phase 1: Immediately read cached location for zero-latency startup
    try {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        final lastPos = LatLng(lastKnown.latitude, lastKnown.longitude);
        setState(() {
          _userLocation = lastPos;
          _fromController.text = 'My Current Location';
          _minibuses = [
            LatLng(lastPos.latitude + 0.003, lastPos.longitude - 0.002),
            LatLng(lastPos.latitude + 0.006, lastPos.longitude + 0.004),
          ];
        });
        _mapController.move(lastPos, 15.5);
      }
    } catch (_) {}

    // Phase 2: Acquire fresh high-accuracy satellite fix
    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      final exactPos = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _userLocation = exactPos;
          _fromController.text = 'My Current Location';
          _isLocating = false;

          // Seed approaching minibuses along corridors near the user
          _minibuses = [
            LatLng(exactPos.latitude + 0.003, exactPos.longitude - 0.002),
            LatLng(exactPos.latitude + 0.006, exactPos.longitude + 0.004),
          ];
        });

        if (_destinationPoint != null) {
          _fetchRoadRoute(exactPos, _destinationPoint!);
          _fitRouteOnMap(exactPos, _destinationPoint!);
        } else {
          _mapController.move(exactPos, 15.8);
        }

        // Keep marker synced if passenger moves
        _positionStream?.cancel();
        _positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position pos) {
          if (mounted) {
            final updatedPos = LatLng(pos.latitude, pos.longitude);
            setState(() {
              _userLocation = updatedPos;
            });
            if (_destinationPoint != null) {
              _fetchRoadRoute(updatedPos, _destinationPoint!);
            }
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  // Call free public OSRM engine for real street curves (avoiding Google Cloud billing)
  Future<void> _fetchRoadRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'];

        if (routes != null && routes.isNotEmpty) {
          final coordinates = routes[0]['geometry']['coordinates'] as List;
          final double distance = routes[0]['distance'] / 1000.0;
          final double duration = routes[0]['duration'] / 60.0;

          if (mounted) {
            setState(() {
              _routePoints = coordinates
                  .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
                  .toList();
              _distanceKm = '${distance.toStringAsFixed(1)} km';
              _durationMins = '${duration.toStringAsFixed(0)} mins';
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error routing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // OpenStreetMap base layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 15.5,
              onTap: (tapPosition, point) {
                // Allow direct tap on map to drop destination pin
                _selectDestination(
                  point,
                  'Pinned on Map (${point.latitude.toStringAsFixed(3)}, ${point.longitude.toStringAsFixed(3)})',
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.taxi_ale',
              ),

              if (_routePoints.isNotEmpty)
                PolylineLayer<Object>(
                  polylines: [
                    Polyline<Object>(
                      points: _routePoints,
                      color: const Color(0xFF2C7480),
                      strokeWidth: 5.5,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation,
                    width: 38,
                    height: 38,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C7480),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                  ),
                  if (_destinationPoint != null)
                    Marker(
                      point: _destinationPoint!,
                      width: 44,
                      height: 44,
                      child: const Icon(Icons.location_on, color: Color(0xFFE53935), size: 44),
                    ),

                  // Approaching minibus vehicles with available seat tags
                  ..._minibuses.map((busPos) {
                    return Marker(
                      point: busPos,
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/taxi_3d.png', fit: BoxFit.contain),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              child: const Text(
                                '3 seats',
                                style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          Positioned(
            right: 18,
            bottom: (_destinationPoint != null && !_isSearchCardExpanded) ? 140 : 250,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _locateAndCenterUser,
              child: _isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2C7480)),
                    )
                  : const Icon(Icons.my_location, color: Color(0xFF2C7480)),
            ),
          ),
          if (_durationMins.isNotEmpty)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.directions_bus, color: Color(0xFF2C7480), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Minibus arriving in $_durationMins ($_distanceKm away)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF1F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: _destinationPoint != null && !_isSearchCardExpanded
                    // Compact trip summary card (leaves 85% of map visible)
                    ? Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C7480),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.directions_bus, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _destinationName.isNotEmpty ? _destinationName : 'Selected Destination',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _durationMins.isNotEmpty
                                      ? 'ETA: ~$_durationMins • 3 Seats Available • 12 Birr'
                                      : 'Calculating route...',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {
                              setState(() {
                                _isSearchCardExpanded = true;
                              });
                            },
                            child: const Text(
                              'Change',
                              style: TextStyle(color: Color(0xFF2C7480), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.my_location, color: Color(0xFF2C7480), size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('From', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                          TextField(
                                            controller: _fromController,
                                            readOnly: true,
                                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_isLocating)
                                      const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2C7480)),
                                      ),
                                  ],
                                ),

                                const Divider(height: 16),

                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Color(0xFFE53935), size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('To', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                          TextField(
                                            controller: _toController,
                                            focusNode: _toFocusNode,
                                            onChanged: _onToTextChanged,
                                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              border: InputBorder.none,
                                              hintText: 'Where to? (e.g. Megenagna, Mexico)',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              suffixIcon: _toController.text.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _toController.clear();
                                                          _destinationPoint = null;
                                                          _routePoints.clear();
                                                          _durationMins = '';
                                                          _distanceKm = '';
                                                        });
                                                      },
                                                      child: const Icon(Icons.close, size: 18, color: Colors.grey),
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Predictive station autocomplete suggestions
                          if (_showPredictions && _predictions.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              constraints: const BoxConstraints(maxHeight: 180),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3)),
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                itemCount: _predictions.length,
                                separatorBuilder: (_, _) => const Divider(height: 1, indent: 48),
                                itemBuilder: (context, index) {
                                  final place = _predictions[index];
                                  final dist = _calcDistance(place.location);

                                  return ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    leading: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2F0F2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.location_city, color: Color(0xFF2C7480), size: 18),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          place.name,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                                        ),
                                        if (place.amharicName.isNotEmpty) ...[
                                          const SizedBox(width: 6),
                                          Text(
                                            place.amharicName,
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${place.subcity} • ~$dist km',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                                    onTap: () {
                                      _selectDestination(place.location, place.name);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],

                          if (!_showPredictions) ...[
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: _quickPlaces.map((name) {
                                  final place = kAddisStations.firstWhere(
                                    (p) => p.name == name,
                                    orElse: () => kAddisStations.first,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ActionChip(
                                      backgroundColor: Colors.white,
                                      elevation: 1,
                                      side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      label: Text(
                                        place.name,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF2C7480)),
                                      ),
                                      avatar: const Icon(Icons.near_me, size: 14, color: Color(0xFF2C7480)),
                                      onPressed: () {
                                        _selectDestination(place.location, place.name);
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C7480),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                if (_destinationPoint != null) {
                                  _selectDestination(_destinationPoint!, _toController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please choose a destination or tap on the map'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search, color: Colors.white, size: 20),
                              label: const Text(
                                'Find Minibuses',
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alias so both names work interchangeably
typedef PassengerHomeScreen = PassengerHomeMapScreen;