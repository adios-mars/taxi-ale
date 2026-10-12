import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/custom_back_button.dart';
import 'driver_route_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  bool _isPhotoUploaded = false;
  String _uploadSource = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Driver License',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C7480),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose where to upload your license photo from',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B9EA8)),
                ),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F0F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2C7480)),
                  ),
                  title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Use device camera', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(modalContext);
                    setState(() {
                      _isPhotoUploaded = true;
                      _uploadSource = 'Camera';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo captured from Camera!'),
                        backgroundColor: Color(0xFF2C7480),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F0F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: Color(0xFF2C7480)),
                  ),
                  title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Select photo from gallery', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(modalContext);
                    setState(() {
                      _isPhotoUploaded = true;
                      _uploadSource = 'Gallery';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo selected from Gallery!'),
                        backgroundColor: Color(0xFF2C7480),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onContinue() {
    String name = _fullNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DriverRouteScreen(),
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
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),
                  const Text(
                    'personal info',
                    style: TextStyle(
                      color: Color(0xFF2C7480),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your detail as they appear on your license',
                    style: TextStyle(
                      color: Color(0xFF6B9EA8),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                      controller: _fullNameController,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Full Name',
                        hintStyle: TextStyle(
                          color: Color(0xFFB5C8CC),
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Driver’s license',
                    style: TextStyle(
                      color: Color(0xFF2C7480),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Take a clear photo of your license for verification',
                    style: TextStyle(
                      color: Color(0xFF6B9EA8),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 180),
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: _isPhotoUploaded
                            ? Border.all(color: const Color(0xFF2C7480), width: 1.5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isPhotoUploaded
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.check_circle, color: Colors.green, size: 36),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'License photo added from $_uploadSource!',
                                  style: const TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Tap to change photo',
                                  style: TextStyle(
                                    color: Color(0xFF2C7480),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE2F0F2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.file_upload_outlined,
                                      color: Color(0xFF4C8A97),
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'take to upload license photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF6B9EA8),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'camera or gallery (*jpg, *png)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFA0C3C9),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387985),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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