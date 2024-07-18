import 'package:flutter/material.dart';

class OptionsCard extends StatelessWidget {
  const OptionsCard({super.key});

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
            _buildIconCard('Identify', Icons.search),
            _buildIconCard('Diagnose', Icons.medical_services),
            _buildIconCard('Book', Icons.book),
            _buildIconCard('Price list', Icons.list),
            _buildIconCard('Guide', Icons.menu_book),
            _buildIconCard('Community', Icons.people),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
