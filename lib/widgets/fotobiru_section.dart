import 'package:flutter/material.dart';

class FotoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Photos Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Photo Kiri (Akbar)
                    Container(
                      width: 140,
                      height: 200,
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

                    // Love Icon Tengah
                    Container(
  width: 60,
  height: 60,
  alignment: Alignment.center,
  child: Icon(
    Icons.favorite,
    color: Color.fromARGB(255, 255, 255, 255),
    size: 40,
  ),
),

                    // Photo Kanan (Wulan)
                    Container(
                      width: 140,
                      height: 200,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}