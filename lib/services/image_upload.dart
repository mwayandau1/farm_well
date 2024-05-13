import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToFirebase(File pickedImage) async {
  try {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}');
    await storageReference.putFile(pickedImage);
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading image $e");
    return '';
  }
}
