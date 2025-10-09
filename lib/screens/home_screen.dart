import 'package:flutter/material.dart';
import 'package:real_beez/screens/ai.dart' as ai;
import 'package:real_beez/screens/enquriy_screen.dart' as enquiry;
import 'package:real_beez/screens/enquriy_screen.dart';
import 'package:real_beez/screens/profile.dart';
import 'package:real_beez/widgets/cutsom_widgets/custom_bottom_bar.dart';
import 'package:real_beez/screens/premium.dart' as premium_screen;
import 'package:real_beez/widgets/cutsom_widgets/swipe_cards.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  int bottomNavIndex = 0;
  late final enquiry.EnquiryController _enquiryController;

  final List<TabItem> tabs = [
    TabItem(icon: Icons.grid_view, label: 'All'),
    TabItem(icon: Icons.apartment, label: 'Apartment'),
    TabItem(icon: Icons.villa, label: 'Villas'),
    TabItem(icon: Icons.park, label: 'Farmlands'),
    TabItem(icon: Icons.landscape, label: 'Open Plots'),
  ];

  // 🔹 Separate gradient colors for "All" tab
  final Color allTabStartColor = Color(0xFF727272);
  final Color allTabEndColor = Color(0xFFD79A2F);
  final List<Color> tabColors = const [
    Color(0xFFD79A2F), // fallback
    Color(0xFF2C3E50),
    Color(0xFF4CAF50),
    Color(0xFF2E7D32),
    Color(0xFFD79A2F),
  ];

  final List<GlobalKey> _tabKeys = [];
  double capsuleWidth = 60;
  double capsuleCenterX = 60;

  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  final List<Map<String, String>> specialOffers = [
    {'title': 'My Home Avatar', 'image': 'assets/images/unlock1.png'},
    {'title': 'Ankura Villas', 'image': 'assets/images/unlock2.png'},
    {'title': 'Prestige City', 'image': 'assets/images/unlock1.png'},
    {'title': 'Jumbooo City', 'image': 'assets/images/unlock2.png'},
  ];

  @override
  void initState() {
    super.initState();
    _enquiryController = enquiry.EnquiryController(
      SubmitEnquiryUseCase(MockEnquiryRepository()),
    );
    _tabKeys.addAll(List.generate(tabs.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCapsulePosition();
    });
  }

  void _updateCapsulePosition() {
    final key = _tabKeys[selectedIndex];
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);
      setState(() {
        capsuleWidth = size.width + 40;
        capsuleCenterX = offset.dx + size.width / 2;
      });
    }
  }

  // Navigation methods - ONLY PROFILE NAVIGATION
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8ECFC),
      body: Stack(
        children: [
          // Main content
          _buildBody(),
          
          // Map Button positioned above bottom bar - FIXED POSITIONING
          if (bottomNavIndex == 0) // Only show on home screen
            Positioned(
              bottom: kBottomNavigationBarHeight + 16, // Position above bottom bar with padding
              right: 16,
              child: _buildMapButton(),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: bottomNavIndex,
        onTabSelected: (i) {
          setState(() {
            bottomNavIndex = i;
          });
        },
      ),
    );
  }

  Widget _buildMapButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xFFD79A2F),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            // Handle map button tap
            print('Map button tapped');
            // Add your map navigation logic here
          },
          child: Icon(
            Icons.map,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // 0: Home, 1: Enquiry, 2: AI Assistant, 3: Premium
    if (bottomNavIndex == 3) {
      return premium_screen.PropertyServicesScreen();
    }
    if (bottomNavIndex == 2) {
      return ai.AiAssistantScreen();
    }
    if (bottomNavIndex == 1) {
      return enquiry.EnquiryScreen(
        propertyId: 'TEMP123',
        summary: enquiry.PropertySummary(
          id: 'TEMP123',
          title: 'Sample Property',
          location: 'Hyderabad',
          imageUrl: 'assets/images/swipe1.png',
          price: 50,
        ),
        controller: _enquiryController,
        onViewDetails: () {
          // TODO: navigate to property detail screen
        },
        onBackToListing: () {
          // TODO: navigate back to property list
        },
      );
    }

    return Stack(
      children: [
        // 🔹 Extend Gradient till Carousel Area - set to 62% of screen height
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.62, // covers ~62% of screen height
            ),
            painter: TopGradientWavePainter(
              selectedIndex == 0 ? null : tabColors[selectedIndex],
              startColor: selectedIndex == 0 ? allTabStartColor : null,
              endColor: selectedIndex == 0 ? allTabEndColor : null,
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // 🔹 Top Bar - Responsive
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 6),
                        Text(
                          "Hyderabad, TG",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Search Bar - Responsive
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                child: Row(
                  children: [
                    // Search box
                    Expanded(
                      child: Container(
                        height: isSmallScreen ? 36 : 40,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Color(0xFFB0BEC5),
                              size: isSmallScreen ? 18 : 20,
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search "Apartments"',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.mic,
                              color: Colors.grey,
                              size: isSmallScreen ? 18 : 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    // Notifications
                    Stack(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: isSmallScreen ? 22 : 28,
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    // Profile avatar - WITH NAVIGATION
                    GestureDetector(
                      onTap: _navigateToProfile,
                      child: CircleAvatar(
                        radius: isSmallScreen ? 14 : 18,
                        backgroundImage:
                            AssetImage("assets/images/submit.png"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Custom TabBar - Responsive
              Stack(
                children: [
                  SizedBox(
                    height: isSmallScreen ? 70 : 84,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedIndex == index;
                        final Color selectedColor =
                            index == 0 ? allTabEndColor : tabColors[index];
                        final Color unselectedColor =
                            selectedIndex == 0 ? Colors.white : Colors.black;
                        return GestureDetector(
                          key: _tabKeys[index],
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              _updateCapsulePosition();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 6),
                              Icon(
                                tabs[index].icon,
                                color: isSelected
                                    ? selectedColor
                                    : unselectedColor,
                                size: isSmallScreen ? 20 : 24,
                              ),
                              SizedBox(height: 4),
                              Text(
                                tabs[index].label,
                                style: TextStyle(
                                  color: isSelected
                                      ? selectedColor
                                      : unselectedColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: isSmallScreen ? 10 : 12,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 36),
                      painter: CapsuleWaveLinePainter(
                        centerX: capsuleCenterX,
                        capsuleWidth: capsuleWidth,
                        capsuleHeight: 26,
                        borderRadius: 10,
                      ),
                    ),
                  ),
                ],
              ),

              // 🔹 Content Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Special offers carousel - Responsive
                      SizedBox(
                        height: isSmallScreen ? 170 : 190,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: isSmallScreen ? 8.0 : 12.0,
                              ),
                              child: Container(
                                width: isSmallScreen ? 60 : 80,
                                height: isSmallScreen ? 60 : 80,
                                margin: EdgeInsets.only(
                                  right: isSmallScreen ? 8 : 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/special_offers.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: specialOffers.length,
                                padEnds: false,
                                itemBuilder: (context, index) {
                                  final offer = specialOffers[index];
                                  return _buildOfferCard(
                                    imageUrl: offer['image']!,
                                    title: offer['title']!,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: specialOffers.length,
                          effect: WormEffect(
                            dotColor: Colors.white54,
                            activeDotColor: Colors.white,
                            dotHeight: 6,
                            dotWidth: 6,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Content based on selected tab
                      if (selectedIndex == 0) ...[
                        PropertyDeckSection(),
                      ] else ...[
                        SizedBox(height: 24),
                        _buildPopularBuildersSection(),
                        SizedBox(height: 20),
                        _buildPromotionalBanner(),
                        SizedBox(height: 20),
                        _buildCategorySection(),
                        SizedBox(height: 20),
                        PropertyDeckSection(),
                      ],

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularBuildersSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final crossAxisCount = screenWidth < 320
        ? 3
        : screenWidth < 400
            ? 4
            : 4;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 16 : 20,
                height: isSmallScreen ? 16 : 20,
                decoration: BoxDecoration(
                  color: Color(0xFFD79A2F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: isSmallScreen ? 10 : 12,
                ),
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Expanded(
                child: Text(
                  'Some Popular Builders',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                width: isSmallScreen ? 16 : 20,
                height: isSmallScreen ? 16 : 20,
                decoration: BoxDecoration(
                  color: Color(0xFFD79A2F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: isSmallScreen ? 10 : 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildBuilderCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBuilderCard(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final builders = [
      {'name': 'PROVINCIA', 'color': Color(0xFFD79A2F), 'textColor': Colors.white},
      {'name': 'SATTVA', 'color': Colors.white, 'textColor': Colors.blue},
      {'name': 'PRESTIGE', 'color': Colors.white, 'textColor': Color(0xFF8B4513)},
      {'name': 'LODHA', 'color': Colors.white, 'textColor': Colors.grey[800]!},
      {'name': 'APARNA', 'color': Colors.white, 'textColor': Colors.black},
      {'name': 'My Home', 'color': Colors.white, 'textColor': Colors.green},
      {'name': 'MY HOME', 'color': Colors.white, 'textColor': Colors.red},
      {'name': 'SMR', 'color': Colors.white, 'textColor': Colors.blue},
    ];

    final builder = builders[index];

    return Container(
      decoration: BoxDecoration(
        color: builder['color'] as Color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            builder['name'] as String,
            style: TextStyle(
              color: builder['textColor'] as Color,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 8 : 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 24 : 30,
            height: isSmallScreen ? 24 : 30,
            decoration: BoxDecoration(
              color: Color(0xFFD79A2F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: isSmallScreen ? 12 : 16,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Text(
              'First 100 People 10% Sale',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final categories = ['2BHK', '3BHK', '4BHK', '5BHK', 'Apartments'];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: isSmallScreen ? 70 : 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Container(
                  width: isSmallScreen ? 65 : 80,
                  margin: EdgeInsets.only(
                    right: isSmallScreen ? 8 : 12,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: isSmallScreen ? 40 : 50,
                        height: isSmallScreen ? 40 : 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.apartment,
                          color: Colors.grey[600],
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Color(0xFFD79A2F) : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: isSmallScreen ? 10 : 12,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 2,
                          margin: EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFFD79A2F),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // REMOVED NAVIGATION from offer cards
  Widget _buildOfferCard({required String imageUrl, required String title}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 400;

    return Container(
      margin: EdgeInsets.only(
        left: 2,
        right: isSmallScreen ? 16 : 24, // Increased spacing
      ),
      constraints: BoxConstraints(
        // Cap card height to avoid vertical overflow in the section
        maxHeight: isSmallScreen ? 150 : 170,
      ),
      width: isSmallScreen
          ? screenWidth * 0.22  // narrower on small screens
          : isMediumScreen
              ? screenWidth * 0.19  // narrower on medium screens
              : screenWidth * 0.16, // narrower on large screens
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    height: isSmallScreen ? 74 : 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  )
                : Image.network(
                    imageUrl,
                    height: isSmallScreen ? 74 : 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "More Details:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 12 : 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD79A2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Unlock the Offers",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 10 : 12,
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

class TabItem {
  final IconData icon;
  final String label;
  TabItem({required this.icon, required this.label});
}

class CapsuleWaveLinePainter extends CustomPainter {
  final double centerX;
  final double capsuleWidth;
  final double capsuleHeight;
  final double borderRadius;

  CapsuleWaveLinePainter({
    required this.centerX,
    required this.capsuleWidth,
    required this.capsuleHeight,
    this.borderRadius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final leftX = centerX - capsuleWidth / 2;
    final rightX = centerX + capsuleWidth / 2;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(leftX, 0);

    path.arcToPoint(
      Offset(leftX + borderRadius, -borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );
    path.lineTo(leftX + borderRadius, -capsuleHeight + borderRadius);
    path.arcToPoint(
      Offset(leftX + borderRadius * 2, -capsuleHeight),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(rightX - borderRadius * 2, -capsuleHeight);
    path.arcToPoint(
      Offset(rightX - borderRadius, -capsuleHeight + borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(rightX - borderRadius, -borderRadius);
    path.arcToPoint(
      Offset(rightX, 0),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);

    canvas.translate(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CapsuleWaveLinePainter oldDelegate) {
    return oldDelegate.centerX != centerX ||
        oldDelegate.capsuleWidth != capsuleWidth ||
        oldDelegate.capsuleHeight != capsuleHeight ||
        oldDelegate.borderRadius != borderRadius;
  }
}

class TopGradientWavePainter extends CustomPainter {
  final Color? color;
  final Color? startColor;
  final Color? endColor;

  TopGradientWavePainter(this.color, {this.startColor, this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: startColor != null && endColor != null
          ? [startColor!, endColor!]
          : [Color(0xFFE8ECFC), color!.withOpacity(0.8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, 0);

    // Stronger, clearer wave: baseline with visible crest and trough
    final double baseline = 28.0; // distance from bottom to baseline
    final double crest = 46.0;    // higher than baseline (moves up)
    final double trough = 12.0;   // lower than baseline (moves down)

    path.lineTo(0, size.height - baseline);

    final double waveWidth = size.width / 3;

    // Up (crest) -> back to baseline -> down (trough) -> back to baseline
    path.quadraticBezierTo(
      waveWidth * 0.25, size.height - crest,
      waveWidth,        size.height - baseline,
    );
    path.quadraticBezierTo(
      waveWidth * 1.5,  size.height - trough,
      waveWidth * 2,    size.height - baseline,
    );
    path.quadraticBezierTo(
      waveWidth * 2.75, size.height - crest,
      size.width,       size.height - baseline,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TopGradientWavePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.startColor != startColor ||
      oldDelegate.endColor != endColor;
}