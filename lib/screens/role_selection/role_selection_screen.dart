import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../passenger/passenger_login_screen.dart';
import '../driver/driver_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C7480),
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageTile(ctx, 'English', 'English', true),
              _buildLanguageTile(ctx, 'አማርኛ', 'Amharic', false),
              _buildLanguageTile(ctx, 'Afaan Oromoo', 'Oromo', false),
              _buildLanguageTile(ctx, 'ትግርኛ', 'Tigrinya', false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF2C7480) : Colors.black87,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF2C7480))
          : null,
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          CustomPaint(
            size: Size(size.width, size.height),
            painter: TopCurvePainter(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _showLanguageDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C7480).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.translate,
                        color: Color(0xFF2C7480),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.35),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'welcome to ',
                            style: GoogleFonts.eduAuVicWaNtPre(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textLight,
                            ),
                          ),
                          TextSpan(
                            text: 'Taxi Ale',
                            style: GoogleFonts.eduAuVicWaNtPre(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'Select the role',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildRoleButton(
                      icon: const SteeringWheelIcon(
                        size: 20,
                        color: AppColors.primaryTeal,
                      ),
                      title: 'Driver',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverLoginScreen(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white.withValues(alpha: 0.4),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withValues(alpha: 0.4),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildRoleButton(
                      icon: const Icon(
                        Icons.person,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                      title: 'Passenger',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PassengerLoginScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primaryTeal,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Recreates Figma's signature asymmetrical wave curve header using Bezier paths
class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.05);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.20,
      size.width,
      size.height * 0.25,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Vector steering wheel rendered on canvas to avoid third-party font/SVG bundle overhead
class SteeringWheelIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SteeringWheelIcon({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SteeringWheelPainter(color: color),
    );
  }
}

class _SteeringWheelPainter extends CustomPainter {
  final Color color;
  _SteeringWheelPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius - 1.0, strokePaint);
    canvas.drawCircle(center, radius * 0.28, fillPaint);
    canvas.drawLine(center, Offset(1.0, center.dy), strokePaint);
    canvas.drawLine(center, Offset(size.width - 1.0, center.dy), strokePaint);
    canvas.drawLine(center, Offset(center.dx, size.height - 1.0), strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}