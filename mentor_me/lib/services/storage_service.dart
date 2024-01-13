import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class StorageService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<File?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<bool> uploadDocument(File? file, String title, String type,
      String school, String courseCode) async {
    try {
      // Upload file to Firebase Storage
      final Reference storageReference =
          storageRef.child('documents').child(file!.path);
      final UploadTask uploadTask = storageReference.putFile(file);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Add document metadata to Firestore
      await FirebaseFirestore.instance
          .collection('resource_documents')
          .doc(school)
          .collection(courseCode)
          .add({
        'title': title,
        'type': type,
        'url': downloadUrl,
        'time': Timestamp.now(),
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<String?> captureImage(MyUser user) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final FirebaseStorage storage = FirebaseStorage.instance;

      try {
        await storage.ref('images/photoOf${user.uid}.png').putFile(imageFile);
        final imageUrl =
            await storage.ref('images/photoOf${user.uid}.png').getDownloadURL();

        return imageUrl;
      } on FirebaseException catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }
}
