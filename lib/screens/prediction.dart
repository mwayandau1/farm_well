import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  File? _imageFile;
  List<dynamic>? _recognitions;
  String? _feedback;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _predictDisease();
    }
  }

  Future<void> _predictDisease() async {
    if (_imageFile != null) {
      final recognitions = await Tflite.runModelOnImage(
        path: _imageFile!.path,
        numResults: 1,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        _recognitions = recognitions;
      });
    }
  }

  Future<void> _sendFeedback() async {
    if (_feedback != null && _feedback!.isNotEmpty) {
      // Send feedback to server or handle it locally
      print('Feedback: $_feedback');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            if (_recognitions != null && _recognitions!.isNotEmpty)
              Text(
                'Predicted Disease: ${_recognitions![0]['label']}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick Image'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Take Picture'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter feedback',
              ),
              onChanged: (value) => setState(() => _feedback = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendFeedback,
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
