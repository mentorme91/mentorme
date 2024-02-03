import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user.dart';


// controls firebase storage manipulation
class StorageService {
  // initialize firebase storage reference
  final storageRef = FirebaseStorage.instance.ref();

  // load a firebase file from its URL
  Future<File?> loadFirebaseFile(String url, String title) async {
    try {
      final PDF = storageRef.child(url);
      final List<int> bytes = await PDF.getData() as List<int>;
      return _storeFile(url, bytes, title);
    } catch (e) {
      return null;
    }
  }

  // store a file in user's device
  Future<File> _storeFile(String url, List<int> bytes, String title) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$title');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  // pick a file from user's device
  Future<File?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // upload a document to firebase
  Future<bool> uploadDocument(File file, String title, String type,
      String school, String courseCode) async {
    try {
      // Upload file to Firebase Storage
      final Reference storageReference =
          storageRef.child('documents').child(file.path);
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
        'path': 'documents/${file.path}',
        'time': Timestamp.now(),
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  // capture can image from user's gallery
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

  // download a file to user's downlaod folder (in android)
  Future<bool> downloadFile(String path, String name) async {
    final ref = storageRef.child(path);
    final downloadPath = await getPathToDownload();

    final File tempFile = File(downloadPath + '/' + '$name.pdf');
    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await OpenFile.open(tempFile.path);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // get the path to the android user's downloads folder
  Future<String> getPathToDownload() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }
}
