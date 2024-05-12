import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<EducationalContent> recentEducationalContent = [
    // Replace with your actual educational content data
    EducationalContent(
      title: 'Tomato Leaf Blight',
      content: 'Learn about the causes and symptoms of tomato leaf blight.',
      imageUrl: 'images/tomato_leaf_blight.jpeg',
    ),
    EducationalContent(
      title: 'Citrus Greening',
      content: 'Understand the impact of citrus greening on your orange trees.',
      imageUrl: 'images/citrus_greening.jpeg',
    ),
  ];

  List<PredictionResult> recentPredictionResults = [
    // Replace with your actual prediction result data
    PredictionResult(
      image: 'images/prediction1.jpeg',
      result: 'Leaf Blight',
    ),
    PredictionResult(
      image: 'images/prediction2.jpeg',
      result: 'Powdery Mildew',
    ),
  ];

  String currentWeather = 'Sunny'; // Replace with your actual weather data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Current Weather: $currentWeather',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            CarouselSlider(
              items: recentEducationalContent.map((content) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              content.imageUrl,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    content.content,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Recent Prediction Results',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            ...recentPredictionResults.map((result) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      result.image,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      'Predicted Disease: ${result.result}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class EducationalContent {
  final String title;
  final String content;
  final String imageUrl;

  EducationalContent({
    required this.title,
    required this.content,
    required this.imageUrl,
  });
}

class PredictionResult {
  final String image;
  final String result;

  PredictionResult({
    required this.image,
    required this.result,
  });
}
