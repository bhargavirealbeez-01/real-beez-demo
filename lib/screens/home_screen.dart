import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomTabBarScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class CustomTabBarScreen extends StatefulWidget {
  @override
  _CustomTabBarScreenState createState() => _CustomTabBarScreenState();
}

class _CustomTabBarScreenState extends State<CustomTabBarScreen> {
  int selectedIndex = 0;

  final List<TabItem> tabs = [
    TabItem(icon: Icons.grid_view, label: 'All', color: Colors.orange),
    TabItem(icon: Icons.apartment, label: 'Apartment', color: Colors.blue),
    TabItem(icon: Icons.villa, label: 'Villas', color: Colors.green),
    TabItem(icon: Icons.park, label: 'Farmlands', color: Colors.brown),
    TabItem(icon: Icons.landscape, label: 'Open Plots', color: Colors.purple),
  ];

  final List<GlobalKey> _tabKeys = [];
  double capsuleWidth = 60;
  double capsuleCenterX = 60;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    Color currentColor = tabs[selectedIndex].color;
    
    return Scaffold(
      backgroundColor: currentColor, // ✅ Top part changes with tab selection
      body: LayoutBuilder(builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        return Stack(
          children: [
            // ✅ Dynamic colored background with wave at top
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: Container(color: currentColor), // dynamic color top
                  ),
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 200, // same height as above
                      color: Color(0xFFF5F5F5),
                    ),
                  ),
                ],
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // 🔹 Top location + profile row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[100]),
                            const SizedBox(width: 6),
                            Text(
                              "Hyderabad, TG",
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey[100]),
                          ],
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.notifications,
                                    color: Colors.grey[100], size: 28),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      "1",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 16),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Search bar with mic
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search "Apartments"',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                          Icon(Icons.mic, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Custom capsule tab bar
                  Stack(
                    children: [
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(tabs.length, (index) {
                            final isSelected = selectedIndex == index;
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
                                  const SizedBox(height: 6),
                                  Icon(
                                    tabs[index].icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tabs[index].label,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
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
                          size: Size(screenWidth, 36),
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

                  // 🔹 Body starts
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // 👉 Special Offer row with scrollable cards
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "SPECIAL OFFER",
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                SizedBox(
                                  height: 180,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: const [
                                        BannerSection(
                                          title: "My Home Avatar",
                                          subtitle: "Unlock the Offers",
                                          color: Color(0xFFD79A2F),
                                        ),
                                        BannerSection(
                                          title: "Ankura Villas",
                                          subtitle: "Unlock the Offers",
                                          color: Color(0xFFD79A2F),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class TabItem {
  final IconData icon;
  final String label;
  final Color color;
  TabItem({required this.icon, required this.label, required this.color});
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


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 20);

    // Simple wave curve
    path.quadraticBezierTo(
        size.width / 4, 0, size.width / 2, 20); // left wave
    path.quadraticBezierTo(
        3 * size.width / 4, 40, size.width, 20); // right wave
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BannerSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const BannerSection(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(Icons.flash_on, color: color),
                  const SizedBox(height: 6),
                  Text("Deal", style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}