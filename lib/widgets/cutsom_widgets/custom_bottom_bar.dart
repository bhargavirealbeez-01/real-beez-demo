import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomBar({super.key, required this.currentIndex, required this.onTabSelected});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home),
    _NavItem(assetIcon: "assets/icons/enquiry.png"),
    _NavItem(assetIcon: "assets/icons/ai_assistant.png"),
    _NavItem(assetIcon: "assets/icons/premium.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 29, right: 29, bottom: 20),
      width: 346,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(62),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isSelected = index == widget.currentIndex;

          return GestureDetector(
            onTap: () {
              widget.onTabSelected(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD79A2F) : Colors.transparent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    item.icon != null
        ? Icon(item.icon, color: Colors.white, size: 24)
        : Image.asset(
            item.assetIcon!,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
    
  ],
),

            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData? icon;
  final String? assetIcon;


  _NavItem({this.icon, this.assetIcon});
}
