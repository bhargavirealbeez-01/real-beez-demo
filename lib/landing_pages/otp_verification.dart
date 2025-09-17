import 'package:flutter/material.dart';
import 'package:real_beez/landing_pages/name_input.dart';
import 'package:real_beez/utils/app_colors.dart';
import 'package:real_beez/widgets/common_widgets/common_text.dart';
import 'package:real_beez/widgets/common_widgets/landing_layout.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  void _submitOtp() {
    final otp = _otpController.text;
    debugPrint("Entered OTP: $otp");

    if (otp.length == 6) {
      // ✅ Navigate to NameInputPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NameInputPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit code")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LandingLayout(
      title: "ENTER THE CODE SENT TO",
      subtitle: widget.phoneNumber,
      showBack: true,
      belowLogo: Column(
        children: [
          const SizedBox(height: 20),

          // RESEND CODE (directly below logo as per design)
          GestureDetector(
            onTap: () {
              debugPrint("Resend OTP tapped");
            },
            child: const CommonText(
              text: "RESEND CODE",
              fontSize: 14,
              isBold: true,
              color: AppColors.textDark,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // OTP input styled as per design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.beeYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // OTP TextField (hidden input, shows • only)
                Expanded(
                  child: TextField(
                    controller: _otpController,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    obscureText: true, // dots like in design
                    obscuringCharacter: "•",
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.length == 6) {
                        _submitOtp();
                      }
                    },
                  ),
                ),

                // White circle with arrow (Next button)
                GestureDetector(
                  onTap: _submitOtp,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        ">",
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
