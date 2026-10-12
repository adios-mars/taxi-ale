import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/custom_back_button.dart';
import 'passenger_home_screen.dart';

class PassengerLocationScreen extends StatelessWidget {
  const PassengerLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.16),
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF387985),
                      size: 110,
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Enable Location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1B4F58),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Taxi Ale needs your location to show nearby taxis on your route and help you see when a minibus is approaching your stop.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B9EA8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 36),
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
                        onPressed: () async {
                          LocationPermission permission = await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                          }
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PassengerHomeMapScreen(),
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.near_me,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Allow Location Access',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          const CustomBackButton(),
        ],
      ),
    );
  }
}