import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

class CarouselSection extends StatelessWidget {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
    'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800',
    'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          cs.CarouselSlider(
            options: cs.CarouselOptions(
              height: 400,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              viewportFraction: 1.0,
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF2d2d2d),
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: Color(0xFF4a4a4a),
                              ),
                            );
                          },
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          // Overlay text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'OUR SPECIAL DAY',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 4,
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '15 • 12 • 2024',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
