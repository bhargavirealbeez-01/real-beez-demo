import 'package:flutter/material.dart';
import 'package:real_beez/landing_pages/register_screen.dart';
import 'package:real_beez/widgets/auth/auth_footer.dart';
import 'package:real_beez/widgets/common_widgets/common_button.dart';
import '../utils/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                 'assets/logo/real_beez_logo.png',
                  width: 200,
                ),
              ),
            ),
            CommonButton(
              text: "Get Started With RealbeeZ",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterNumberScreen()),
                );
              },
              backgroundColor: AppColors.beeYellow,
              textColor: AppColors.white,
            ),
            const SizedBox(height: 16),
            AuthFooter(
              text: "Already have an account?",
            
              linkText: "Log In",
              onLinkTap: () {
                // Navigate to login screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
