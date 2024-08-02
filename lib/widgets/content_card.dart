import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String truncatedContent;

  const ContentCard({
    super.key,
    required this.data,
    required this.truncatedContent,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: SizedBox(
                height: 150, // Fixed height for the image
                child: Image.network(
                  widget.data['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle title overflow
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.truncatedContent,
                    style: const TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis, // Handle content overflow
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
