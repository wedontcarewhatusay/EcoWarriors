import 'dart:async';
import 'dart:io';


import 'package:cameraapp/screens/preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Label {
  //
  // String imagePath;
  // set imgPath(String imagePath) {
  //   this.imagePath = imagePath;
  // }

  Future<void> detectLabels(String imagePath) async {
    print("this is image path detectLabels ${imagePath}");
    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFilePath(imagePath);
    final ImageLabeler labelDetector = FirebaseVision.instance.imageLabeler();

    final List<ImageLabel> labels =
    await labelDetector.processImage(visionImage);

    List<String> labelTexts = new List();
    for (ImageLabel label in labels) {
      final String text = label.text;

      labelTexts.add(text);
    }

    final String downloadURL = await _uploadFile(imagePath) ;

    await _addItem(downloadURL, labelTexts);
  }
    Future<void> _addItem(String downloadURL, List<String> labels) async {
    await FirebaseFirestore.instance
        .collection('items')
        .add(<String, dynamic>{'downloadURL': downloadURL, 'labels': labels});
  }

  Future<String> _uploadFile(imagePath) async {
    final File file = File(imagePath);
    print("this is image path uploadFile ${imagePath}");

    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
    final firebase_storage.UploadTask uploadTask = ref.putFile(
      file,
      firebase_storage.SettableMetadata(
        contentLanguage: 'en',
      ),
    );

    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }


}