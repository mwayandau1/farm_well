import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:farm_well/services/predictImageUpload.dart'; // Ensure this path is correct
import 'cure.dart'; // Import the Cure class

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  File? _imageFile;
  String? _predictionResult;
  bool _isLoading = false;
  String? _diseaseLabel;
  bool _isPredicting = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/trained_model.tflite",
      labels: "assets/labels.txt",
    );
    print(res);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = null; // Reset the prediction result
      });
    }
  }

  Future<void> _predictDisease() async {
    if (_isPredicting) return; // Prevent multiple simultaneous predictions

    setState(() {
      _isLoading = true; // Show loading indicator
      _isPredicting = true;
    });

    try {
      if (_imageFile != null) {
        String imageUrl = await uploadImageToFirebase(_imageFile!);

        if (imageUrl.isNotEmpty) {
          var recognitions = await Tflite.runModelOnImage(
            path: _imageFile!.path,
            imageMean: 0.0,
            imageStd: 255.0,
            numResults: 1,
            threshold: 0.2,
            asynch: true,
          );

          if (recognitions != null && recognitions.isNotEmpty) {
            final recognition = recognitions.first;
            final String label = recognition['label'];
            final double confidence = recognition['confidence'];

            final prediction =
                'Predicted Disease: $label\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%';

            // Get the cure for the predicted disease
            final cureText = Cure.getDiseaseCure(label);

            // Store prediction result and cure in Firestore
            await FirebaseFirestore.instance.collection('predictions').add({
              'image_url': imageUrl,
              'prediction': prediction,
              'cure': cureText,
              'timestamp': FieldValue.serverTimestamp(),
            });

            setState(() {
              _predictionResult = prediction; // Set the prediction result
              _diseaseLabel = label; // Set the disease label
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Prediction failed. Please try again.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Image upload failed. Please try again.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
        _isPredicting = false;
      });
    }
  }

  void _showCureModal(String disease) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Cure(disease);
      },
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
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
                          'Make sure the entire leaf is in the frame and\nthat the image is clear.',
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
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        if (_predictionResult != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _predictionResult!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_diseaseLabel != null) {
                                          _showCureModal(_diseaseLabel!);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Show Cure'),
                                    ),
                                  ],
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
