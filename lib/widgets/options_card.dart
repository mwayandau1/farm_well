import 'package:flutter/material.dart';

class OptionsCard extends StatefulWidget {
  const OptionsCard({super.key});

  @override
  State<OptionsCard> createState() => _OptionsCardState();
}

class _OptionsCardState extends State<OptionsCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildIconCard('Diagnose', Icons.medical_services, 0,
                () => _navigateTo(context, '/identify')),
            _buildIconCard('Guide', Icons.menu_book, 1,
                () => _navigateTo(context, '/guide')),
            _buildIconCard('Community', Icons.people, 2,
                () => _navigateTo(context, '/community')),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(
      String title, IconData icon, int index, VoidCallback onTap) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.1 : 0.05),
              blurRadius: isHovered ? 8 : 4,
              offset: Offset(0, isHovered ? 4 : 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isHovered ? 12 : 8),
                child: Icon(icon, size: isHovered ? 48 : 40),
              ),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}
