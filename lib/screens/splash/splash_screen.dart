import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../role_selection/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate to Role Selection screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.background,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            color: AppColors.primaryTeal,
            colorBlendMode: BlendMode.multiply,
          ),
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 70,
                    child: Image.asset(
                      AppAssets.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Taxi Ale',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 5.5,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}