import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/custom_back_button.dart';
import 'passenger_verify_phone_screen.dart';
import 'passenger_location_screen.dart';

class PassengerLoginScreen extends StatefulWidget {
  const PassengerLoginScreen({super.key});

  @override
  State<PassengerLoginScreen> createState() => _PassengerLoginScreenState();
}

class _PassengerLoginScreenState extends State<PassengerLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    FocusScope.of(context).unfocus();

    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() => _phoneError = 'Please enter your phone number');
      return;
    }

    // Ethiopian mobile numbers are 9 digits excluding national prefix (e.g. 9xxxxxxxx / 7xxxxxxxx)
    if (phone.length < 9) {
      setState(() => _phoneError = 'Phone number must be 9 digits (e.g. 912345678)');
      return;
    }

    setState(() => _phoneError = null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerVerifyPhoneScreen(initialPhone: phone),
      ),
    );
  }

  void _onGoogleSignIn() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GoogleIcon(size: 38),
              const SizedBox(height: 14),
              const Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your account for Taxi Ale',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pop(modalContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signed in with Google successfully!'),
                      backgroundColor: Color(0xFF2C7480),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PassengerLocationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF2C7480),
                        child: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                            Text('mars@gmail.com', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      // Fix background position and handle keyboard inset via scroll padding to avoid jumpy layouts
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.40,
            child: Image.asset(
              AppAssets.background,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: size.height * 0.32,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(26.0, 26.0, 26.0, bottomInset > 0 ? bottomInset + 24.0 : 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _phoneError != null ? Colors.redAccent : Colors.grey.shade400,
                          width: _phoneError != null ? 1.5 : 1.1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const EthiopianFlag(width: 25, height: 16),
                          const SizedBox(width: 8),
                          Text(
                            '+251',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 22,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              onChanged: (value) {
                                if (_phoneError != null) {
                                  setState(() => _phoneError = null);
                                }
                              },
                              style: const TextStyle(fontSize: 15.5, letterSpacing: 0.5),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '912345678',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          if (_phoneController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _phoneController.clear();
                                setState(() => _phoneError = null);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Icon(Icons.clear, size: 18, color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_phoneError != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          _phoneError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF62929E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _onSignIn,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            'Or continue With',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                child: GoogleIcon(size: 22),
                                onTap: _onGoogleSignIn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSocialButton(
                                child: const Icon(
                                  Icons.apple,
                                  size: 28,
                                  color: Colors.black,
                                ),
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSocialButton(
                                child: FacebookIcon(size: 24),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          height: 1.45,
                        ),
                        children: const [
                          TextSpan(text: 'If you are creating a new account, '),
                          TextSpan(
                            text: 'Terms & conditions',
                            style: TextStyle(
                              color: Color(0xFF2F80ED),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(
                              color: Color(0xFF2F80ED),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' will apply.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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

  Widget _buildSocialButton({required Widget child, required VoidCallback onTap}) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Vector rendering of the Ethiopian national flag to guarantee crisp rendering across DPIs
class EthiopianFlag extends StatelessWidget {
  final double width;
  final double height;

  const EthiopianFlag({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: Container(color: const Color(0xFF078930))),
                Expanded(child: Container(color: const Color(0xFFFCDD09))),
                Expanded(child: Container(color: const Color(0xFFDA121A))),
              ],
            ),
            Center(
              child: Container(
                width: height * 0.45,
                height: height * 0.45,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F47AF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFCDD09),
                    size: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleIcon extends StatelessWidget {
  final double size;
  const GoogleIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

/// Canvas-drawn 4-color Google glyph to eliminate third-party raster image assets
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final red = Paint()..color = const Color(0xFFEA4335);
    final blue = Paint()..color = const Color(0xFF4285F4);
    final green = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final stroke = radius * 0.28;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);

    ringPaint.color = blue.color;
    canvas.drawArc(rect, -0.4, 1.2, false, ringPaint);
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - stroke / 2, radius, stroke),
      blue,
    );

    ringPaint.color = green.color;
    canvas.drawArc(rect, 0.8, 1.4, false, ringPaint);

    ringPaint.color = yellow.color;
    canvas.drawArc(rect, 2.2, 1.2, false, ringPaint);

    ringPaint.color = red.color;
    canvas.drawArc(rect, 3.4, 1.8, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FacebookIcon extends StatelessWidget {
  final double size;
  const FacebookIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.75,
            fontWeight: FontWeight.bold,
            fontFamily: 'sans-serif',
          ),
        ),
      ),
    );
  }
}