import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// ---------------------- Styling constants ----------------------
const Color kBackground = Color(0xFFF8F3E7); // light cream/beige
const Color kGoldTop = Color(0xFFD7A44B);
const Color kGoldBottom = Color(0xFF876E3B);
const Color kGoldText = Color(0xFFD7A44B);
const double kPagePadding = 16.0;
const double kAppBarAvatarSize = 44.0;
const double kBackIconSize = 24.0;
const double kCardCornerRadius = 22.0;
const double kVideoCornerRadius = 15.0;
const double kPlayCircleRadius = 28.0;
const double kMinTapSize = 44.0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Plan Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackground,
      ),
      home: const PremiumPlanScreen(),
    );
  }
}

/// ---------------------- PremiumPlanScreen ----------------------
class PremiumPlanScreen extends StatelessWidget {
  const PremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double cardWidth = screenW * 0.7;
    final double videoHeight = 200.0;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPagePadding),
          child: Column(
            children: [
              // ---------------------- AppBar ----------------------
              _buildTopBar(context),

              // ---------------------- Centered content ----------------------
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ---------------------- Title ----------------------
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Watch Our Video about Premium plan and Services',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // ---------------------- Video Thumbnail ----------------------
                        _buildVideoThumbnail(
                          width: screenW - (kPagePadding * 2),
                          height: videoHeight,
                        ),

                        const SizedBox(height: 16),

                        // ---------------------- About Plans ----------------------
                        const Text(
                          'About Plans',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 22),

                        // ---------------------- Premium Plan Card ----------------------
                        Container(
                          width: cardWidth,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kCardCornerRadius),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [kGoldTop, kGoldBottom],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 22),

                              // Title and Price Centered
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Premium Plan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Rs 499-/Life Time',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Bullet Points Centered
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    _PlanBullet(text: 'Access to Services', centered: true),
                                    SizedBox(height: 12),
                                    _PlanBullet(text: 'You will get One Lead', centered: true),
                                    SizedBox(height: 12),
                                    _PlanBullet(
                                      text: 'You can Add Your property Listing',
                                      centered: true,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Subscribe Button Centered
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: SizedBox(
                                    width: cardWidth * 0.5,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Subscribe tapped!'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Subscribe',
                                        style: TextStyle(
                                          color: kGoldText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------------- AppBar with back & profile ----------------------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: kMinTapSize,
              minHeight: kMinTapSize,
            ),
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: kBackIconSize,
            ),
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: kAppBarAvatarSize / 2,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80',
              ),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 1.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ---------------------- Video Thumbnail ----------------------
  Widget _buildVideoThumbnail({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kVideoCornerRadius),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&q=80',
          ),
        ),
      ),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kPlayCircleRadius),
            onTap: () {},
            child: Container(
              width: kPlayCircleRadius * 2,
              height: kPlayCircleRadius * 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.play_arrow, size: 16, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------- Bullet Point Widget ----------------------
class _PlanBullet extends StatelessWidget {
  final String text;
  final bool centered;
  const _PlanBullet({required this.text, this.centered = false});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
      ],
    );

    return centered ? Center(child: row) : row;
  }
}
