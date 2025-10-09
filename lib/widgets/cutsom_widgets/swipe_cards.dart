import 'package:flutter/material.dart';
import 'package:real_beez/screens/map_screen.dart';
import 'package:real_beez/screens/property_details_screen.dart';
import 'package:real_beez/utils/app_colors.dart';
import 'package:real_beez/models/property.dart';
import 'package:real_beez/repositories/property_repository.dart';

class PropertyDeckSection extends StatefulWidget {
  const PropertyDeckSection({super.key});

  @override
  State<PropertyDeckSection> createState() => _PropertyDeckSectionState();
}

class _PropertyDeckSectionState extends State<PropertyDeckSection> {
  final PropertyRepository _repository = const PropertyRepository();
  List<Property> properties = [];
  Offset _dragOffset = Offset.zero;
  int? _draggingIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await _repository.loadProperties();
    if (!mounted) return;
    setState(() {
      properties = list;
    });
  }

  void _onPanStart(int index, DragStartDetails details) {
    if (_draggingIndex != null) return;
    setState(() {
      _draggingIndex = index;
      _dragOffset = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_draggingIndex == null) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_draggingIndex == null) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final shouldDismiss = _dragOffset.dy > screenHeight * 0.25;

    if (shouldDismiss) {
      setState(() {
        final removed = properties.removeAt(_draggingIndex!);
        properties.insert(0, removed);
        _draggingIndex = null;
        _dragOffset = Offset.zero;
      });
    } else {
      setState(() {
        _dragOffset = Offset.zero;
        _draggingIndex = null;
      });
    }
  }

  // Navigation to property details
  void _navigateToPropertyDetails(Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(
        
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardW = 280.0; // Further decreased from 300.0
    final cardH = 260.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: Text(
                  "Featured Sites",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.filter_list,
                      size: 18, color: Colors.black),
                  label: const Text(
                    "Filter",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Deck with Maps Button positioned below
        Stack(
          children: [
            // Deck Cards
            Center(
              child: SizedBox(
                width: cardW,
                height: cardH + 60, // Reduced height to remove space
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildDeckWidgets(cardW, cardH),
                ),
              ),
            ),
            
            // Maps Button - Positioned at bottom of deck section with spacing
            Positioned(
              bottom: 4, // Decreased bottom spacing
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 102,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(61, 61, 61, 0.8),
                        Color(0xFFD79A2F),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RealEstateHome(),
                        ),
                      );
                    },
                    icon: const AnimatedCompassIcon(),
                    label: const Text(
                      "Maps",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildDeckWidgets(double cardW, double cardH) {
    final widgets = <Widget>[];
    final count = properties.length;
    final mid = (count - 1) / 2.0;

    for (int i = 0; i < count; i++) {
      final rel = i - mid;
      final rotation = rel * 0.10;
      final translateX = rel * 24.0;
      final translateY = (rel.abs()) * 6.0;
      final scale = 1.0 - (rel.abs() * 0.03);

      Widget card = PropertyCard(
        property: properties[i],
        width: cardW,
        height: cardH,
        onTap: () => _navigateToPropertyDetails(properties[i]),
      );

      if (_draggingIndex == i) {
        card = Transform.translate(
          offset: Offset(translateX + _dragOffset.dx, translateY + _dragOffset.dy),
          child: Transform.rotate(
            angle: rotation + (_dragOffset.dx * 0.001),
            child: Transform.scale(scale: scale, child: card),
          ),
        );
      } else {
        card = Transform.translate(
          offset: Offset(translateX, translateY),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(scale: scale, child: card),
          ),
        );
      }

      card = GestureDetector(
        onPanStart: (d) => _onPanStart(i, d),
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: card,
      );

      widgets.add(card);
    }

    return widgets;
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.width,
    required this.height,
    this.onTap,
  });

  bool get isNew => property.status == 'pre_launch';

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _circleIcon(Icons.location_on, Colors.orange),
                          const SizedBox(width: 8),
                          _circleIcon(Icons.favorite_border, Colors.orange),
                        ],
                      ),
                    ],
                  ),

                  Text(
                    "${property.address.area}, ${property.address.city}",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  const Text(
                    "Price Range start from",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  Text(
                    _formatPrice(property.price, property.currency),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Image section
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    child: _buildImage(property.images.isNotEmpty ? property.images.first.url : 'assets/images/swipe1.png'),
                  ),

                  // New badge
                  if (isNew)
                    Positioned(
                      bottom: 100,
                      left: 12,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/new.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              "New",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
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

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          )
        ],
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 50),
        ),
      );
    }
    
    // Check if it's a local asset path
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey, size: 50),
            ),
          );
        },
      );
    } else {
      // Network image
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey, size: 50),
            ),
          );
        },
      );
    }
  }

  static String _formatPrice(int price, String currency) {
    final symbol = currency == 'INR' ? '₹' : '';
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (i > 0 && ((count == 3) || (count > 3 && (count - 3) % 2 == 0))) {
        buffer.write(',');
      }
    }
    final formatted = buffer.toString().split('').reversed.join();
    return "$symbol$formatted";
  }
}

class AnimatedCompassIcon extends StatefulWidget {
  const AnimatedCompassIcon({super.key});

  @override
  State<AnimatedCompassIcon> createState() => _AnimatedCompassIconState();
}

class _AnimatedCompassIconState extends State<AnimatedCompassIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.explore, color: Colors.white, size: 22),
    );
  }
}