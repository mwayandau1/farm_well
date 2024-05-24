import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_well/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EducationalScreen extends StatefulWidget {
  const EducationalScreen({super.key});

  @override
  State<EducationalScreen> createState() => _EducationalScreenState();
}

class _EducationalScreenState extends State<EducationalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _imageFile;

  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _cancelImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _submitForm(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final content = _contentController.text;
      final imageFile = _imageFile;
      final imageUrl = await uploadImageToFirebase(imageFile!);
      await FirebaseFirestore.instance.collection("educational_content").add({
        "title": title,
        "content": content,
        "image": imageUrl,
      });
    }
    if (!context.mounted) {
      return;
    }
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Educational Content'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap:
                      isLoading ? null : () => _pickImage(ImageSource.gallery),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image),
                        const SizedBox(width: 8.0),
                        Text(
                          _imageFile == null
                              ? 'Upload Image'
                              : 'Image Selected',
                          style: TextStyle(
                            color: _imageFile == null
                                ? Colors.grey[600]
                                : Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_imageFile != null) ...[
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: _cancelImage,
                            child: const Icon(Icons.cancel, color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        _imageFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () => _submitForm(context),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
