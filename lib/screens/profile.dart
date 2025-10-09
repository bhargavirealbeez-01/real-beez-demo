import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Settings',
      home: const ProfileSettingsScreen(),
    );
  }
}

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  static const Color backgroundColor = Color(0xFFF8F3E7);
  static const Color cardColor = Colors.white;
  static const Color goldColor = Color(0xFFD7A44B);
  static const Color chevronColor = Color(0xFFACB3B7);
  static const Color dividerColor = Color(0xFFF1F1EF);
  static const Color bellColor = Color(0xFFF6C768);

  final List<_SettingItem> settingsItems = const [
    _SettingItem(label: 'Booking Details', icon: Icons.calendar_today, key: Key('booking')),
    _SettingItem(label: 'My Bio', icon: Icons.badge, key: Key('bio')),
    _SettingItem(label: 'Premium Plan Details', icon: Icons.stars, key: Key('premium')),
    _SettingItem(label: 'Privacy', icon: Icons.lock, key: Key('privacy')),
    _SettingItem(label: 'Help', icon: Icons.help_outline, key: Key('help')),
    _SettingItem(label: 'About', icon: Icons.info_outline, key: Key('about')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildProfileSection(),
                  const SizedBox(height: 20),
                  _buildSettingsCard(),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: _buildLogoutButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const Key('back_arrow'),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
            onPressed: () {},
            tooltip: 'Back',
          ),
          Stack(
            children: [
              IconButton(
                key: const Key('notification_bell'),
                icon: Icon(Icons.notifications, color: bellColor, size: 18),
                onPressed: () {},
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(height: 10),
        const Text(
          'Mohan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          ...settingsItems.asMap().entries.map((entry) {
            int idx = entry.key;
            _SettingItem item = entry.value;
            return Column(
              children: [
                InkWell(
                  key: item.key,
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  splashColor: goldColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14), // reduced from 20 → 14
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                              color: goldColor, shape: BoxShape.circle),
                          child: Icon(item.icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 14), // reduced spacing between icon and text
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: chevronColor, size: 18),
                      ],
                    ),
                  ),
                ),
                if (idx != settingsItems.length - 1)
                  const Divider(color: dividerColor, height: 0.8), // slightly thinner divider
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('logout_button'),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: goldColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class _SettingItem {
  final String label;
  final IconData icon;
  final Key key;
  const _SettingItem({required this.label, required this.icon, required this.key});
}
