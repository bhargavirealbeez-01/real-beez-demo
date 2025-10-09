import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Details UI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        fontFamily: 'Roboto',
      ),
      home: const PropertyDetailsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PageController _photosController = PageController(viewportFraction: 0.78);

  final List<String> photoUrls = [
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    'https://images.unsplash.com/photo-1565182999561-9f4d7a3b5d7b',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
  ];

  final List<String> floorPlanUrls = [
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    'https://images.unsplash.com/photo-1565182999561-9f4d7a3b5d7b',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
  ];

  final List<Map<String, String>> testimonials = [
    {
      'name': 'Sarah',
      'text':
          'The villa was beautifully designed, spacious, and had a perfect balance of luxury and comfort.',
      'image': 'https://i.pravatar.cc/100?img=47',
    },
    {
      'name': 'Jhon',
      'text':
          'Amazing experience! The interiors are elegant, and the private green space is a dream.',
      'image': 'https://i.pravatar.cc/100?img=5',
    },
    {
      'name': 'Priya',
      'text':
          'Peaceful neighborhood and high-quality finishings. Worth every penny for the comfort.',
      'image': 'https://i.pravatar.cc/100?img=32',
    },
  ];

  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(size)),
              SliverToBoxAdapter(child: _buildInfoCard()),
              SliverToBoxAdapter(child: _buildFeatures()),
              SliverToBoxAdapter(child: _sectionTitle('More Photos And Videos')),
              SliverToBoxAdapter(child: _buildPhotosCarousel()),
              SliverToBoxAdapter(child: _sectionTitle('Floor Plans And Brochure')),
              SliverToBoxAdapter(child: _buildFloorPlans()),
              SliverToBoxAdapter(child: _downloadButton()),
              SliverToBoxAdapter(child: _sectionTitle("What Our Client's Say!")),
              SliverToBoxAdapter(child: _buildTestimonials()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Stack(
      children: [
        Container(
          height: size.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            image: DecorationImage(
              image: NetworkImage(photoUrls[0]),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleIcon(Icons.arrow_back),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: const DecorationImage(
                          image: NetworkImage('https://flagcdn.com/w80/in.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isFavourite = !_isFavourite),
                      child: _circleIcon(
                        _isFavourite ? Icons.favorite : Icons.favorite_border,
                        filled: _isFavourite,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _circleIcon(IconData icon, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: filled ? Colors.white70 : Colors.black45,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: filled ? Colors.red : Colors.white, size: 20),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ankura Villas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Gachibowli', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text('80 Lakhs - 1 Crs',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '"Experience luxury living in these spacious villas, designed with modern architecture, elegant interiors, and private green spaces. Each villa offers a perfect blend of comfort and sophistication, ideal for families seeking a serene lifestyle."',
            style: TextStyle(color: Colors.black87, height: 1.4),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          const Text('Read More...', style: TextStyle(color: Colors.blueAccent)),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final items = [
      {'label': 'Bedroom', 'icon': Icons.bed},
      {'label': 'Parking', 'icon': Icons.directions_car},
      {'label': 'Kitchen', 'icon': Icons.kitchen},
      {'label': 'Club House', 'icon': Icons.pool},
      {'label': 'More...', 'icon': Icons.more_horiz},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((it) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Icon(it['icon'] as IconData, size: 20, color: Colors.black87),
                  const SizedBox(height: 6),
                  Text(it['label'] as String, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPhotosCarousel() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _photosController,
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(photoUrls[index], fit: BoxFit.cover, width: double.infinity),
                ),
                Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.black),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloorPlans() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: floorPlanUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(floorPlanUrls[index],
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(6),
                    child: Text(
                      'Cover Biley  Elly Floma',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _downloadButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        onPressed: () {},
        child: const Text('Download Brochure & Floor Plan'),
      ),
    );
  }

  Widget _buildTestimonials() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: testimonials.length,
        itemBuilder: (context, index) {
          final t = testimonials[index];
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['text']!,
                    style:
                        const TextStyle(color: Colors.white, height: 1.4, fontSize: 15),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(t['image']!),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        t['name']!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(
                          5,
                          (_) => const Icon(Icons.star, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
      ]),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.directions),
              label: const Text('Direction'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.call),
              label: const Text('Call'),
            ),
          ),
        ],
      ),
    );
  }
}
