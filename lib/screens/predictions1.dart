import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  bool _hasPrediction = false;

  String url = "http://10.42.0.1:5000/predict";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (pickedFile != null) {
      File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          _imageFile = croppedFile;
          _predictionResult = null;
          _diseaseLabel = null;
          _hasPrediction = false;
        });
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> _predictDisease() async {
    if (_isPredicting) return;

    setState(() {
      _isLoading = true;
      _isPredicting = true;
    });

    try {
      if (_imageFile != null) {
        String imageUrl = await uploadImageToFirebase(_imageFile!);

        if (imageUrl.isNotEmpty) {
          var request = http.MultipartRequest('POST', Uri.parse(url));
          request.files
              .add(await http.MultipartFile.fromPath('file', _imageFile!.path));
          var response = await request.send();

          if (response.statusCode == 200) {
            var responseData = await http.Response.fromStream(response);
            var result = json.decode(responseData.body);

            if (result['prediction'] != null) {
              final predictionData = result['prediction'];
              final String label = predictionData['label'];
              final double confidence = predictionData['confidence'];

              final prediction =
                  'Predicted Disease: ${formatLabel(label)}\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%';

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
                _hasPrediction = true;
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
                  content:
                      Text('Prediction request failed. Please try again.')),
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
        _isLoading = false;
        _isPredicting = false;
      });
    }
  }

  String formatLabel(String label) {
    return label
        .replaceAll('___', ' ')
        .replaceAll('__', ' ')
        .replaceAll('_', ' ')
        .title();
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
      _hasPrediction = false;
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
                        if (!_hasPrediction)
                          ElevatedButton(
                            onPressed: _predictDisease,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
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
                        if (_predictionResult != null && _hasPrediction)
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
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: _resetPrediction,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Predict Again'),
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

extension StringExtensions on String {
  String title() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
