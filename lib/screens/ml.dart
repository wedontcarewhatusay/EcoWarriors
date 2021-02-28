import 'dart:async';
import 'dart:io';
import 'dart:ui';

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

  Future<void> detectLabels(String imagePath, String type) async {
    List<String> labelTexts = new List();

    if (type == "image") {
      print("this is image path detectLabels ${imagePath}");
      final FirebaseVisionImage visionImage =
      FirebaseVisionImage.fromFilePath(imagePath);
      final ImageLabeler labelDetector = FirebaseVision.instance.imageLabeler();

      final List<ImageLabel> labels =
      await labelDetector.processImage(visionImage);
      for (ImageLabel label in labels) {
        final String text = label.text;

        labelTexts.add(text);
      }
    } else if (type== "text"){
      print("this is image path detectLabels ${imagePath}");
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
      //final ImageLabeler labelDetector = FirebaseVision.instance.cloudImageLabeler();
      final TextRecognizer labelDetector = FirebaseVision.instance.cloudTextRecognizer();
      final VisionText visionText = await labelDetector.processImage(visionImage);

      String text = visionText.text;
      for (TextBlock block in visionText.blocks) {
        final Rect boundingBox = block.boundingBox;
        final List<Offset> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<RecognizedLanguage> languages = block.recognizedLanguages;
        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          for (TextElement element in line.elements) {
            final String text = element.text.toString();
            if (text == "GL") {
              //labelTexts.add(text);
              labelTexts.add("glass");
            }
            else if (text == "PP" || text == "PVC" || text == "PET" || text == "HDPE") {
              //labelTexts.add(text);
              labelTexts.add("plastic");
            }
            else if (text == "PAP") {
              //labelTexts.add(text);
              labelTexts.add("paper");
            }
            else if (text == "ALU") {
              //labelTexts.add(text);
              labelTexts.add("aluminium");
            }
            else if (text == "FE") {
              //labelTexts.add(text);
              labelTexts.add("iron");
            }
            else {
              labelTexts.add("none");
            }
          }
        }
      }
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