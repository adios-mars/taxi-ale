import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/custom_back_button.dart';
import 'driver_location_screen.dart';

/// Place model for Addis Ababa taxi terminals
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

/// Popular minibus terminals in Addis Ababa
const List<AddisPlace> kDriverStations = [
  AddisPlace(name: 'Mexico Square', amharicName: 'ሜክሲኮ', subcity: 'Kirkos', location: LatLng(9.0108, 38.7445)),
  AddisPlace(name: 'Bole Medhanialem', amharicName: 'ቦሌ መድኃኔዓለም', subcity: 'Bole', location: LatLng(8.9950, 38.7880)),
  AddisPlace(name: 'Megenagna', amharicName: 'መገናኛ', subcity: 'Yeka', location: LatLng(9.0205, 38.8020)),
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
  AddisPlace(name: 'Gerji', amharicName: 'ገርጂ', subcity: 'Bole', location: LatLng(8.9980, 38.8150)),
  AddisPlace(name: 'CMC', amharicName: 'ሲኤምሲ', subcity: 'Yeka', location: LatLng(9.0220, 38.8450)),
  AddisPlace(name: 'Ayat', amharicName: 'አያት', subcity: 'Yeka', location: LatLng(9.0240, 38.8750)),
  AddisPlace(name: 'Jemo', amharicName: 'ጀምኦ', subcity: 'Nifas Silk', location: LatLng(8.9550, 38.7050)),
  AddisPlace(name: 'Lebu', amharicName: 'ለቡ', subcity: 'Nifas Silk', location: LatLng(8.9580, 38.7250)),
];

class DriverRouteScreen extends StatefulWidget {
  const DriverRouteScreen({super.key});

  @override
  State<DriverRouteScreen> createState() => _DriverRouteScreenState();
}

class _DriverRouteScreenState extends State<DriverRouteScreen> {
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController(text: 'Mexico Square');
  final TextEditingController _toController = TextEditingController(text: 'Bole Medhanialem');

  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  final MapController _mapController = MapController();

  LatLng _startPoint = const LatLng(9.0108, 38.7445);
  LatLng _endPoint = const LatLng(8.9950, 38.7880);

  List<LatLng> _routePoints = [];
  String _distanceKm = '';
  String _durationMins = '';
  bool _isLoadingRoute = false;

  List<AddisPlace> _predictions = [];
  bool _isSelectingFrom = false;
  bool _isSelectingTo = false;

  final List<Map<String, String>> _popularRoutes = [
    {'from': 'Mexico Square', 'to': 'Bole Medhanialem'},
    {'from': 'Megenagna', 'to': 'Piazza'},
    {'from': 'Torhailoch', 'to': 'Megenagna'},
    {'from': 'Saris', 'to': 'Stadium'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRoadRoute(_startPoint, _endPoint);

    _fromFocusNode.addListener(() {
      if (_fromFocusNode.hasFocus) {
        setState(() {
          _isSelectingFrom = true;
          _isSelectingTo = false;
          _filterPredictions(_fromController.text);
        });
      }
    });

    _toFocusNode.addListener(() {
      if (_toFocusNode.hasFocus) {
        setState(() {
          _isSelectingTo = true;
          _isSelectingFrom = false;
          _filterPredictions(_toController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    super.dispose();
  }

  void _filterPredictions(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _predictions = kDriverStations.take(5).toList();
      } else {
        _predictions = kDriverStations.where((place) {
          return place.name.toLowerCase().contains(q) ||
              place.amharicName.contains(q) ||
              place.subcity.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _selectStation(AddisPlace place, bool isFrom) {
    setState(() {
      if (isFrom) {
        _fromController.text = place.name;
        _startPoint = place.location;
        _isSelectingFrom = false;
        _fromFocusNode.unfocus();
      } else {
        _toController.text = place.name;
        _endPoint = place.location;
        _isSelectingTo = false;
        _toFocusNode.unfocus();
      }
      _predictions.clear();
    });

    _fetchRoadRoute(_startPoint, _endPoint);
  }

  void _applyRoutePreset(String fromName, String toName) {
    final fromPlace = kDriverStations.firstWhere((p) => p.name == fromName, orElse: () => kDriverStations[0]);
    final toPlace = kDriverStations.firstWhere((p) => p.name == toName, orElse: () => kDriverStations[1]);

    setState(() {
      _fromController.text = fromPlace.name;
      _toController.text = toPlace.name;
      _startPoint = fromPlace.location;
      _endPoint = toPlace.location;
      _isSelectingFrom = false;
      _isSelectingTo = false;
      _predictions.clear();
    });

    _fromFocusNode.unfocus();
    _toFocusNode.unfocus();
    _fetchRoadRoute(_startPoint, _endPoint);
  }

  // Free OSRM driving route API
  Future<void> _fetchRoadRoute(LatLng start, LatLng end) async {
    setState(() => _isLoadingRoute = true);

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
              _isLoadingRoute = false;
            });

            // Smoothly frame map to show the entire route
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                final bounds = LatLngBounds.fromPoints([start, end]);
                _mapController.fitCamera(
                  CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(40),
                  ),
                );
              } catch (_) {
                final centerLat = (start.latitude + end.latitude) / 2;
                final centerLng = (start.longitude + end.longitude) / 2;
                _mapController.move(LatLng(centerLat, centerLng), 13.5);
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  void _onContinue() {
    final plate = _plateController.text.trim();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your plate number'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverLocationScreen(
          routeFrom: _fromController.text.trim().isNotEmpty ? _fromController.text.trim() : 'Mexico Square',
          routeTo: _toController.text.trim().isNotEmpty ? _toController.text.trim() : 'Bole Medhanialem',
          plateNumber: plate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F1F4),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.background,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),
                  const Text(
                    'Plate number & Route',
                    style: TextStyle(
                      color: Color(0xFF2C7480),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Minibus Plate Number',
                    style: TextStyle(
                      color: Color(0xFF2C7480),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _plateController,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. 3-A12345 AA',
                        hintStyle: TextStyle(
                          color: Color(0xFFB5C8CC),
                          fontSize: 14.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Add your route',
                    style: TextStyle(
                      color: Color(0xFF2C7480),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your route so passengers know your destination.',
                    style: TextStyle(
                      color: Color(0xFF6B9EA8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.trip_origin,
                              color: Color(0xFF1E88E5),
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'From (Start Terminal)',
                                    style: TextStyle(
                                      color: Color(0xFF8A9FA3),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextField(
                                    controller: _fromController,
                                    focusNode: _fromFocusNode,
                                    onChanged: (val) {
                                      setState(() => _isSelectingFrom = true);
                                      _filterPredictions(val);
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                                      border: InputBorder.none,
                                      hintText: 'Start station',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade200, height: 18),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFE53935),
                              size: 24,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'To (End Terminal)',
                                    style: TextStyle(
                                      color: Color(0xFF8A9FA3),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextField(
                                    controller: _toController,
                                    focusNode: _toFocusNode,
                                    onChanged: (val) {
                                      setState(() => _isSelectingTo = true);
                                      _filterPredictions(val);
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                                      border: InputBorder.none,
                                      hintText: 'End station',
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
                  if ((_isSelectingFrom || _isSelectingTo) && _predictions.isNotEmpty) ...[
                    const SizedBox(height: 8),
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
                            title: Text(
                              place.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                            ),
                            subtitle: Text(
                              '${place.subcity} ${place.amharicName.isNotEmpty ? "• ${place.amharicName}" : ""}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                            onTap: () => _selectStation(place, _isSelectingFrom),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _popularRoutes.map((route) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            backgroundColor: Colors.white,
                            elevation: 1,
                            side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            label: Text(
                              '${route['from']} ⇄ ${route['to']}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF2C7480)),
                            ),
                            avatar: const Icon(Icons.alt_route, size: 14, color: Color(0xFF2C7480)),
                            onPressed: () => _applyRoutePreset(route['from']!, route['to']!),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _startPoint,
                              initialZoom: 13.5,
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
                                    point: _startPoint,
                                    width: 36,
                                    height: 36,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E88E5),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 3),
                                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'A',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Marker(
                                    point: _endPoint,
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFFE53935),
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_durationMins.isNotEmpty)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.directions_bus, color: Color(0xFF2C7480), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$_distanceKm • ~$_durationMins',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: FloatingActionButton.small(
                              heroTag: 'driver_map_recenter',
                              backgroundColor: Colors.white,
                              elevation: 3,
                              onPressed: () => _fetchRoadRoute(_startPoint, _endPoint),
                              child: _isLoadingRoute
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2C7480)),
                                    )
                                  : const Icon(Icons.crop_free, color: Color(0xFF2C7480)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387985),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _onContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const CustomBackButton(),
        ],
      ),
    );
  }
}