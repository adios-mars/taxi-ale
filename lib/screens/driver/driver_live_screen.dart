import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DriverLiveScreen extends StatefulWidget {
  final String routeFrom;
  final String routeTo;
  final String plateNumber;

  const DriverLiveScreen({
    super.key,
    required this.routeFrom,
    required this.routeTo,
    required this.plateNumber,
  });

  @override
  State<DriverLiveScreen> createState() => _DriverLiveScreenState();
}

class _DriverLiveScreenState extends State<DriverLiveScreen> {
  final MapController _mapController = MapController();

  LatLng _driverLocation = const LatLng(9.0108, 38.7445);
  bool _isLocating = true;
  StreamSubscription<Position>? _positionStream;

  // Standard Toyota HiAce minibus capacity in Addis Ababa (14 passengers)
  int _availableSeats = 4;
  final int _maxSeats = 14;

  final List<LatLng> _routePoints = const [];
  bool _isBroadcasting = true;

  @override
  void initState() {
    super.initState();
    _startLiveGpsTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  //  Lock onto live GPS and continuously broadcast driver position
  Future<void> _startLiveGpsTracking() async {
    setState(() => _isLocating = true);

    try {
      // First check last known position
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        final pos = LatLng(lastKnown.latitude, lastKnown.longitude);
        setState(() {
          _driverLocation = pos;
        });
        _mapController.move(pos, 16.0);
      }

      // Fetch fresh position
      final fresh = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final exact = LatLng(fresh.latitude, fresh.longitude);
      if (mounted) {
        setState(() {
          _driverLocation = exact;
          _isLocating = false;
        });
        _mapController.move(exact, 16.0);
      }

      // Continuously stream live GPS coordinates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((Position p) {
        if (mounted && _isBroadcasting) {
          final newPos = LatLng(p.latitude, p.longitude);
          setState(() {
            _driverLocation = newPos;
          });
        }
      });
    } catch (_) {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _incrementSeats() {
    if (_availableSeats < _maxSeats) {
      setState(() => _availableSeats++);
    }
  }

  void _decrementSeats() {
    if (_availableSeats > 0) {
      setState(() => _availableSeats--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _driverLocation,
              initialZoom: 16.0,
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
                    point: _driverLocation,
                    width: 60,
                    height: 60,
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
                              color: _availableSeats > 0 ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            child: Text(
                              '$_availableSeats seats',
                              style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _isBroadcasting ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                        boxShadow: _isBroadcasting
                            ? [
                                BoxShadow(
                                  color: Colors.green.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _isBroadcasting ? 'LIVE BROADCASTING' : 'OFFLINE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  color: _isBroadcasting ? const Color(0xFF2C7480) : Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2F0F2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  widget.plateNumber.isNotEmpty ? widget.plateNumber : 'Minibus',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color(0xFF2C7480),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${widget.routeFrom} ➔ ${widget.routeTo}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 230,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () => _mapController.move(_driverLocation, 16.0),
              child: _isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2C7480)),
                    )
                  : const Icon(Icons.my_location, color: Color(0xFF2C7480)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF1F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F0F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.airline_seat_recline_normal, color: Color(0xFF2C7480), size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Seats',
                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$_availableSeats / $_maxSeats Seats Free',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _decrementSeats,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F0F2),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF2C7480), width: 1.5),
                              ),
                              child: const Icon(Icons.remove, color: Color(0xFF2C7480), size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _incrementSeats,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C7480),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isBroadcasting ? Colors.redAccent.shade700 : const Color(0xFF2C7480),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          setState(() => _isBroadcasting = !_isBroadcasting);
                          if (!_isBroadcasting) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.stop_circle_outlined, color: Colors.white, size: 20),
                        label: Text(
                          _isBroadcasting ? 'End Route / Go Offline' : 'Start Broadcasting',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
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
