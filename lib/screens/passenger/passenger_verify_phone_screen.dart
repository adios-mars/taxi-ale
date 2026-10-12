import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/custom_back_button.dart';
import 'passenger_otp_screen.dart';

class PassengerVerifyPhoneScreen extends StatefulWidget {
  final String initialPhone;
  const PassengerVerifyPhoneScreen({super.key, this.initialPhone = ''});

  @override
  State<PassengerVerifyPhoneScreen> createState() => _PassengerVerifyPhoneScreenState();
}

class _PassengerVerifyPhoneScreenState extends State<PassengerVerifyPhoneScreen> {
  late String _phoneNumber;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.initialPhone;
  }

  void _onKeyPress(String value) {
    if (_phoneNumber.length < 9) {
      setState(() {
        _phoneNumber += value;
        _errorMessage = null;
      });
    }
  }

  void _onBackspace() {
    if (_phoneNumber.isNotEmpty) {
      setState(() {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _showSendOptionsSheet() {
    if (_phoneNumber.length < 9) {
      setState(() {
        _errorMessage = 'Please enter a valid 9-digit phone number';
      });
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
                        children: [
                          const TextSpan(
                            text: 'Send to  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '+251 $_phoneNumber',
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1E293B), size: 22),
                  title: const Text(
                    'Send code by SMS',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  ),
                  onTap: () {
                    Navigator.pop(modalContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PassengerOtpScreen(phoneNumber: _phoneNumber),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                ListTile(
                  leading: const Icon(Icons.chat, color: Color(0xFF1E293B), size: 22),
                  title: const Text(
                    'Send code by WhatsApp',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  ),
                  onTap: () {
                    Navigator.pop(modalContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PassengerOtpScreen(phoneNumber: _phoneNumber),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Color(0xFF1E293B), size: 22),
                  title: const Text(
                    'Edit phone number',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  ),
                  onTap: () => Navigator.pop(modalContext),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
            top: size.height * 0.33,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _errorMessage != null ? Colors.redAccent : const Color(0xFFB0BEC5),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const _EthiopianFlag(),
                            const SizedBox(width: 8),
                            const Text(
                              '+251',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF607D8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(width: 1, height: 22, color: const Color(0xFFCFD8DC)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _phoneNumber.isEmpty ? 'phone number' : _phoneNumber,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  color: _phoneNumber.isEmpty ? const Color(0xFFB0BEC5) : const Color(0xFF263238),
                                  fontWeight: _phoneNumber.isEmpty ? FontWeight.normal : FontWeight.w600,
                                  letterSpacing: _phoneNumber.isEmpty ? 0 : 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5E939D),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _showSendOptionsSheet,
                          child: const Text(
                            'verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // In-app numeric dialer formatted to Figma specs
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8FA),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            _buildKeypadRow(['1', '2', '3']),
                            const SizedBox(height: 8),
                            _buildKeypadRow(['4', '5', '6']),
                            const SizedBox(height: 8),
                            _buildKeypadRow(['7', '8', '9']),
                            const SizedBox(height: 8),
                            _buildBottomKeypadRow(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const CustomBackButton(),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _buildKeyButton(
              onTap: () => _onKeyPress(key),
              child: Text(
                key,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomKeypadRow() {
    return Row(
      children: [
        const Expanded(child: SizedBox(height: 46)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _buildKeyButton(
              onTap: () => _onKeyPress('0'),
              child: const Text('0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _buildKeyButton(
              onTap: _onBackspace,
              child: const Icon(Icons.backspace_outlined, size: 22, color: Color(0xFF1E293B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyButton({required Widget child, required VoidCallback onTap}) {
    return SizedBox(
      height: 46,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 0.5,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _EthiopianFlag extends StatelessWidget {
  const _EthiopianFlag();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(child: Container(color: const Color(0xFF078930))),
              Expanded(child: Container(color: const Color(0xFFFCDD09))),
              Expanded(child: Container(color: const Color(0xFFDA121A))),
            ],
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFF0F47AF), shape: BoxShape.circle),
            child: const Icon(Icons.star, size: 6, color: Color(0xFFFCDD09)),
          ),
        ],
      ),
    );
  }
}