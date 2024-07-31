import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CropCard extends StatefulWidget {
  const CropCard({super.key});

  @override
  State<CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> {
  int _currentIndex = 0;

  final List<Map<String, String>> crops = [
    {'name': 'Cashew', 'imageUrl': 'images/cashew.jpeg'},
    {'name': 'Pepper', 'imageUrl': 'images/pepper.jpeg'},
    {'name': 'Cassava', 'imageUrl': 'images/cassava.jpeg'},
    {'name': 'Maize', 'imageUrl': 'images/maize.jpeg'},
    {'name': 'Rice', 'imageUrl': 'images/rice.jpeg'},
    {'name': 'Potato', 'imageUrl': 'images/potato.jpeg'},
    {'name': 'Orange', 'imageUrl': 'images/orange.jpeg'},
    {'name': 'Tomato', 'imageUrl': 'images/tomato.jpeg'},
    {'name': 'Soybean', 'imageUrl': 'images/soyabean.jpeg'},
  ];

  List<Widget> _buildCrops() {
    return crops.map((crop) {
      return _buildCropCard(crop['name']!, crop['imageUrl']!);
    }).toList();
  }

  Widget _buildCropCard(String name, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: _buildCrops(),
          options: CarouselOptions(
            height: 120,
            viewportFraction: 0.3,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: crops.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _navigateTo(
                  context, '/${entry.value['name']!.toLowerCase()}'),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
