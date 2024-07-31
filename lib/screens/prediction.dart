import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:farm_well/services/predictImageUpload.dart';
import 'cure.dart';

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
  bool _modelLoaded = false;
  Interpreter? _interpreter;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('trained_30_float32.tflite');
      final labelsFile = await rootBundle.loadString('assets/labels.txt');
      setState(() {
        _labels = labelsFile.split('\n');
        _modelLoaded = true;
      });
    } catch (e) {
      print('Error loading model: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading model: $e')),
      );
      setState(() {
        _modelLoaded = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = null;
        _diseaseLabel = null;
      });
    }
  }

  Future<void> _predictDisease() async {
    if (_isPredicting || _imageFile == null || _interpreter == null) return;

    setState(() {
      _isLoading = true;
      _isPredicting = true;
    });

    try {
      String imageUrl = await uploadImageToFirebase(_imageFile!);

      if (imageUrl.isNotEmpty) {
        final imageProcessor = ImageProcessorBuilder()
            .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
            .build();
        final inputImage = TensorImage.fromFile(_imageFile!);
        final processedImage = imageProcessor.process(inputImage);

        final outputBuffer =
            TensorBuffer.createFixedSize([1, 40], TfLiteType.float32);
        _interpreter!.run(processedImage.buffer, outputBuffer.buffer);

        final confidences = outputBuffer.getDoubleList();
        final maxConfidenceIndex = confidences.indexWhere((confidence) =>
            confidence == confidences.reduce((a, b) => a > b ? a : b));

        final String label = _labels[maxConfidenceIndex];
        final double confidence = confidences[maxConfidenceIndex];

        final prediction =
            'Predicted Disease: $label\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%';
        final cureText = Cure.getDiseaseCure(label);

        await FirebaseFirestore.instance.collection('predictions').add({
          'image_url': imageUrl,
          'prediction': prediction,
          'cure': cureText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _predictionResult = prediction;
          _diseaseLabel = label;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Image upload failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
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

  void _resetPrediction() {
    setState(() {
      _imageFile = null;
      _predictionResult = null;
      _diseaseLabel = null;
    });
  }

  @override
  void dispose() {
    _interpreter?.close();
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
                          onPressed: _modelLoaded ? _predictDisease : null,
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
                                      child: const Text('View Cure'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: _resetPrediction,
                          child: const Text(
                            'Predict another image',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
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
