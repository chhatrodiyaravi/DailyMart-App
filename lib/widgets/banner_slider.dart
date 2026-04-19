import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  static const List<String> _banners = [
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200',
    'https://images.unsplash.com/photo-1543168256-418811576931?w=1200',
    'https://images.unsplash.com/photo-1608797178974-15b35a64ede9?w=1200',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          viewportFraction: 0.92,
          enlargeCenterPage: true,
        ),
        items: _banners.map((item) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.green.shade100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.local_grocery_store,
                          color: Colors.green,
                          size: 40,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    bottom: 14,
                    child: Text(
                      'Mega Grocery Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
