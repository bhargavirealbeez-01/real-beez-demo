import 'package:flutter/material.dart';
import 'package:real_beez/screens/home_screen.dart';
import 'package:real_beez/utils/app_colors.dart';
import 'package:real_beez/widgets/common_widgets/common_button.dart';
import 'package:real_beez/widgets/common_widgets/common_text.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  // void _onSubmit() {
  //   final name = _nameController.text.trim();
  //   if (name.isEmpty) {
  //     setState(() {
  //       _errorMessage = "Please enter your name";
  //     });
  //     return;
  //   }

  //   setState(() {
  //     _errorMessage = null; // clear error if valid
  //   });

  //  
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => const SuccessScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(40), 
  child: AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
      onPressed: () => Navigator.of(context).pop(),
    ),
  ),
),

      
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: "What's your name?",
              isBold: true,
              fontSize: 16,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name, // alphabetic keyboard
              decoration: InputDecoration(
                hintText: "Enter Your Name",
                hintStyle: const TextStyle(color: AppColors.greyText),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.beeYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.beeYellow),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              CommonText(
                text: _errorMessage!,
                color: Colors.red,
                fontSize: 12,
              ),
            ],

            const Spacer(),
            CommonButton(
              text: "Lets Started",
              //onPressed : _onSubmit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  HomeScreen()),
                );
              },
              backgroundColor: AppColors.beeYellow,
              textColor: AppColors.white,
              
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Image.asset(
          'assets/images/submit.png', 
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
