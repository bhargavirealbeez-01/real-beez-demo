import 'dart:async';

import 'package:flutter/material.dart';
import 'package:real_beez/screens/map_with_booking_button.dart';
import 'package:real_beez/utils/app_colors.dart';

const Color kBackground = Color(0xFFF7F7FB);
const Color kPillBg = Color(0xFFEFEFEF);
const Color kIconGray = Color(0xFFA6A6A6);
const Color kSubtitleGray = Color(0xFF8C8C8C);
const Color kDescGray = Color(0xFF5E5E5E);
const Color kPriceGray = Color(0xFF242424);
const Color kGold = Color(0xFFFFD066);
const Color kImageError = Color(0xFFF0F0F0);

const double kMinTap = 44.0;

BoxShadow kCardShadow = BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 12,
  offset: Offset(0, 6),
);

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({Key? key}) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isDescriptionExpanded = false;
  bool _isBookmarked = false;
  bool _showMoreFeatures = false;
  
  // Carousel state
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    // Start auto-sliding carousel
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _imagePageController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_imagePageController.hasClients) {
        final nextIndex = (_currentImageIndex + 1) % 5; // assuming 5 images
        _imagePageController.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onImagePageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Property'),
          content: Text('Share this property with others'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _shareViaWhatsApp(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.message, color: Colors.green),
                  SizedBox(width: 8),
                  Text('WhatsApp'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _shareViaEmail(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Email'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _copyToClipboard(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Copy Link'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _shareViaWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening WhatsApp...')),
    );
  }

  void _shareViaEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening Email...')),
    );
  }

  void _copyToClipboard(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Property link copied to clipboard!')),
    );
  }

  void _showBookmarkMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property bookmarked!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openDirections(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening directions to Ankura Villas, Gachibowli...')),
    );
  }

  void _makeCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Property Agent'),
          content: Text('Would you like to call the property agent?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling +91 98765 43210...')),
                );
              },
              child: Text('Call'),
            ),
          ],
        );
      },
    );
  }

  void _bookVisit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book a Visit'),
          content: Text('Schedule a visit to Ankura Villas, Gachibowli'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Visit request submitted! We\'ll contact you soon.')),
                );
              },
              child: Text('Book Visit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              slivers: [
                // Hero image section
                SliverToBoxAdapter(
                  child: Container(
                    height: 280,
                    child: _HeroImageSection(
                      isBookmarked: _isBookmarked,
                      onBookmarkTap: () {
                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });
                        _showBookmarkMessage(context);
                      },
                      onShareTap: () {
                        _showShareDialog(context);
                      },
                      pageController: _imagePageController,
                      currentIndex: _currentImageIndex,
                      onPageChanged: _onImagePageChanged,
                    ),
                  ),
                ),
                
                // Property Info Card as a sliver
                SliverToBoxAdapter(
                  child: _PropertyInfoCard(
                    isDescriptionExpanded: _isDescriptionExpanded,
                    showMoreFeatures: _showMoreFeatures,
                    onReadMoreTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    onMoreFeaturesTap: () {
                      setState(() {
                        _showMoreFeatures = !_showMoreFeatures;
                      });
                    },
                    onDirectionTap: () => _openDirections(context),
                    onCallTap: () => _makeCall(context),
                    onBookVisitTap: () => _bookVisit(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------
// Hero Image Section with Carousel
// -----------------------
class _HeroImageSection extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _HeroImageSection({
    Key? key,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onShareTap,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image Carousel
        PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          itemCount: 5, // 5 sample images
          itemBuilder: (context, index) {
            return Image.asset(
              index % 2 == 0 ? 'assets/images/swipe1.png' : 'assets/images/swipe.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: kImageError),
            );
          },
        ),

        // Carousel indicator dots - Positioned higher up
        Positioned(
          bottom: 40, // Moved up from 20 to 40
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index ? Colors.white : Colors.white54,
                ),
              );
            }),
          ),
        ),

        // translucent appbar + icons
        Positioned(
          left: 12,
          right: 12,
          top: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).maybePop(),
                background: Colors.black.withOpacity(0.35),
                iconColor: Colors.white,
                size: 42,
              ),

              Row(
                children: [
                  _SmallPillIcon(
                    icon: Icons.share,
                    onTap: onShareTap,
                  ),
                  SizedBox(width: 8),
                  _SmallPillIcon(
                    icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    onTap: onBookmarkTap,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

// Circle icon used for back & other main icons
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color background;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.background = const Color(0x55000000),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        splashColor: kGold.withOpacity(0.1),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    );
  }
}

// small pill buttons on top right of image
class _SmallPillIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallPillIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: kGold.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: 40, minHeight: 40),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// -----------------------
// Property Info Card (now scrollable as part of main content)
// -----------------------
class _PropertyInfoCard extends StatelessWidget {
  final bool isDescriptionExpanded;
  final bool showMoreFeatures;
  final VoidCallback onReadMoreTap;
  final VoidCallback onMoreFeaturesTap;
  final VoidCallback onDirectionTap;
  final VoidCallback onCallTap;
  final VoidCallback onBookVisitTap;

  const _PropertyInfoCard({
    Key? key,
    required this.isDescriptionExpanded,
    required this.showMoreFeatures,
    required this.onReadMoreTap,
    required this.onMoreFeaturesTap,
    required this.onDirectionTap,
    required this.onCallTap,
    required this.onBookVisitTap,
  }) : super(key: key);

  // Short and full description
  String get _description =>
      isDescriptionExpanded
          ? 'Experience luxury living in these spacious villas, designed with modern architecture, elegant interiors, and private green spaces. Each villa offers a perfect blend of comfort and sophistication, ideal for families seeking a serene lifestyle. These villas feature premium amenities including a swimming pool, gymnasium, children\'s play area, and 24/7 security. The location provides easy access to schools, hospitals, shopping centers, and major business districts.'
          : 'Experience luxury living in these spacious villas, designed with modern architecture, elegant interiors, and private green spaces. Each villa offers a perfect blend of comfort and sophistication, ideal for families seeking a serene lifestyle.';

  // Base features
  List<Widget> get _baseFeatures => [
        _FeaturePill(icon: Icons.king_bed, label: 'Bedroom'),
        _FeaturePill(icon: Icons.directions_car, label: 'Parking'),
        _FeaturePill(icon: Icons.kitchen, label: 'Kitchen'),
        _FeaturePill(icon: Icons.house, label: 'Club House'),
      ];

  // Extra features
  List<Widget> get _extraFeatures => [
        _FeaturePill(icon: Icons.pool, label: 'Swimming Pool'),
        _FeaturePill(icon: Icons.fitness_center, label: 'Gym'),
        _FeaturePill(icon: Icons.security, label: 'Security'),
        _FeaturePill(icon: Icons.local_parking, label: 'Visitor Parking'),
        _FeaturePill(icon: Icons.elevator, label: 'Elevator'),
        _FeaturePill(icon: Icons.wifi, label: 'WiFi'),
      ];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Title + Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ankura Villas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '80 Lakhs - 1 Cr',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kPriceGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Gachibowli',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kSubtitleGray,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Price Range start from',
                            style: TextStyle(fontSize: 12, color: kSubtitleGray),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Description + Read More
                  Text(
                    _description,
                    style: TextStyle(fontSize: 14, color: kDescGray, height: 1.4),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onReadMoreTap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(44, 24),
                      ),
                      child: Text(
                        isDescriptionExpanded ? 'Read Less....' : 'Read More....',
                        style: TextStyle(fontSize: 14, color: Color(0xFF3454D1), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Features
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ..._baseFeatures,
                      if (showMoreFeatures) ..._extraFeatures,
                      GestureDetector(
                        onTap: onMoreFeaturesTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            showMoreFeatures ? 'Show Less....' : 'More.....',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3454D1),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Divider between sections
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  SizedBox(height: 24),

                  // More Photos and Videos Section
                  _SectionTitle('More Photos and Videos'),
                  SizedBox(height: 12),
                  _PhotosCarousel(),

                  // Divider between sections
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  SizedBox(height: 24),

                  // Floor Plans And Brochure Section
                  _SectionTitle('Floor Plans And Brochure'),
                  SizedBox(height: 12),
                  _FloorPlanSection(),

                  // Divider between sections
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  SizedBox(height: 24),

                  // What Our Client's Say Section
                  _SectionTitle('What Our Client\'s Say!'),
                  SizedBox(height: 12),
                  _TestimonialsCarousel(),

                  // Bottom spacing before action buttons
                  SizedBox(height: 30),
                ],
              ),
            ),

            // Action Buttons Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: onDirectionTap,
                        icon: Icon(Icons.navigation, color: Colors.white, size: 20),
                        label: Text('Direction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.beeYellow,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: onCallTap,
                        icon: Icon(Icons.call, color: Colors.white, size: 20),
                        label: Text('Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.beeYellow,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                       onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.beeYellow,
                          side: BorderSide(color: Color(0xFFE6E0D6)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Book a Visit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        splashColor: kGold.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: kPillBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: kIconGray),
              SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------
// Section Title
// -----------------------
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }
}

// -----------------------
// Photos Carousel (horizontal)
// -----------------------
class _PhotosCarousel extends StatelessWidget {
  const _PhotosCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => i % 2 == 0 ? 'assets/images/swipe1.png' : 'assets/images/swipe.png');
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        padding: EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, index) {
          final url = items[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    url,
                    fit: BoxFit.cover,
                    width: 180,
                    errorBuilder: (_, __, ___) => Container(color: kImageError),
                  ),
                ),
                if (index == 1)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------
// Floor Plans & Brochure
// -----------------------
class _FloorPlanSection extends StatelessWidget {
  const _FloorPlanSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/swipe1.png',
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: kImageError, height: 120),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=60',
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: kImageError, height: 120),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.beeYellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              'Download Brochure & Floor Plan',
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------
// Testimonials Carousel
// -----------------------
class _TestimonialsCarousel extends StatefulWidget {
  const _TestimonialsCarousel({Key? key}) : super(key: key);

  @override
  State<_TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<_TestimonialsCarousel> {
  final PageController _pc = PageController(viewportFraction: 0.86);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(3, (i) => i);
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _pc,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _TestimonialCard(),
          );
        },
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 17, 
              decoration: BoxDecoration(
                color: kGold, 
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), 
                  topRight: Radius.circular(14)
                )
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The villa was beautifully designed, spacious, with a lovely garden and excellent location.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF474747)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: kGold)),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=60'),
                              onBackgroundImageError: (_, __) {},
                              backgroundColor: kImageError,
                            ),
                            SizedBox(width: 8),
                            Text('John', style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PropertyDetailScreen(),
  ));
}