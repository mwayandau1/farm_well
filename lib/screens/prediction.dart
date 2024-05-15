import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  File? _imageFile;
  String? _predictionResult;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = null; // Reset the prediction result
      });
      // Call your prediction function here
    }
  }

  void _predictDisease() {
    // Call your prediction function here
    // Set the _predictionResult based on the prediction logic
    setState(() {
      _predictionResult =
          'Predicted Disease: Leaf Blight'; // Replace with actual prediction result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_imageFile == null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/plant_background.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_imageFile != null)
                    Image.file(
                      _imageFile!,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  if (_imageFile == null)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Take a photo of your plant',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Make sure the entire leave is in the frame and\nthat the image is clear.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Use Camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: const Text(
                            'Upload from gallery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_imageFile != null)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _predictDisease,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Predict'),
                        ),
                        if (_predictionResult != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _predictionResult!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
      ),
    );
  }
}
