import 'package:flutter/material.dart';

class FotoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final photoWidth = (screenWidth - 100) * 0.35;
    final photoHeight = photoWidth * 1.43;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Photo Kiri (Akbar)
                  Flexible(
                    child: Container(
                      width: photoWidth,
                      height: photoHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(-4, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/akbar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF2d2d2d),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF4a4a4a),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Photo Kanan (Wulan)
                  Flexible(
                    child: Container(
                      width: photoWidth,
                      height: photoHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/wulan.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF2d2d2d),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF4a4a4a),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Love Icon Tengah
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}