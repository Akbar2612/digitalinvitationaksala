import 'package:flutter/material.dart';

class BottomNavMobile extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuItemTapped;

  const BottomNavMobile({
    Key? key,
    required this.selectedIndex,
    required this.onMenuItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuButton(icon: Icons.home, label: 'HOME', index: 0),
              _buildMenuButton(
                icon: Icons.favorite,
                label: 'PENGANTIN',
                index: 1,
              ),
              _buildMenuButton(
                icon: Icons.calendar_month,
                label: 'ACARA\n& LOKASI',
                index: 2,
              ),
              _buildMenuButton(
                icon: Icons.favorite_border,
                label: 'LOVE\nSTORY',
                index: 3,
              ),
              _buildMenuButton(
                icon: Icons.photo_library,
                label: 'FOTO',
                index: 4,
              ),
              _buildMenuButton(
                icon: Icons.chat_sharp,
                label: 'UCAPAN',
                index: 5,
              ),
              _buildMenuButton(
                icon: Icons.card_giftcard,
                label: 'WEEDING\nGIFT',
                index: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onMenuItemTapped(index),
      splashColor: const Color(0xFFD4AF37).withOpacity(0.2),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD4AF37).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFB0B0B0),
                size: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 6,
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFB0B0B0),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.8,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
