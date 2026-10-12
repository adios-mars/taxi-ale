import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'passenger_location_screen.dart';

class PassengerOtpScreen extends StatefulWidget {
  final String phoneNumber;
  const PassengerOtpScreen({super.key, required this.phoneNumber});

  @override
  State<PassengerOtpScreen> createState() => _PassengerOtpScreenState();
}

class _PassengerOtpScreenState extends State<PassengerOtpScreen> {
  String _otp = '';
  int _secondsRemaining = 52;
  Timer? _timer;

  // Mock verification passcode for portfolio demo environment before backend SMS gateway integration
  static const String _validOtp = '1234';

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo SMS code: 1234'),
          backgroundColor: Color(0xFF2C7480),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 52;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_otp.length < 4) {
      setState(() => _otp += value);
    }
  }

  void _onBackspace() {
    if (_otp.isNotEmpty) {
      setState(() => _otp = _otp.substring(0, _otp.length - 1));
    }
  }

  void _onContinue() {
    if (_otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 4 digits'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_otp == _validOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone verified successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PassengerLocationScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code! Use 1234 for test.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Verify your phone number',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2B30),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Check your SMS messages. We've sent you the\nPIN +251 ${widget.phoneNumber.isNotEmpty ? widget.phoneNumber : '91243567809'}",
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF64748B),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        final hasValue = index < _otp.length;
                        final digit = hasValue ? _otp[index] : '';
                        final isFocused = index == _otp.length;

                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isFocused ? AppColors.primaryTeal : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive SMS? ",
                                style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                              ),
                              GestureDetector(
                                onTap: _secondsRemaining == 0
                                    ? () {
                                        _startTimer();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('New demo PIN sent: 1234'),
                                            backgroundColor: Color(0xFF2C7480),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  'Resend Code',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: _secondsRemaining == 0
                                        ? AppColors.primaryTeal
                                        : const Color(0xFF5A8E97),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
                              children: [
                                const TextSpan(text: 'you can resend code in '),
                                TextSpan(
                                  text: '$_secondsRemaining s',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E939D),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _onContinue,
                        child: const Text(
                          'continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 10),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 10),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 10),
                  _buildBottomKeypadRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
        const Expanded(child: SizedBox(height: 48)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _buildKeyButton(
              onTap: () => _onKeyPress('0'),
              child: const Text('0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
      height: 48,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}