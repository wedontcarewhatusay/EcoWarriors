import 'package:cameraapp/screens/preview.dart';
import 'package:flutter/material.dart';
import 'package:cameraapp/screens/camera.dart';


class HomeScreen extends StatelessWidget {

  gotoCamera(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
      // MaterialPageRoute(builder: (context) => InfoScreen()),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Re:Track'),
      ),
      body: Center(
        child: Container (
          child: Align (
          alignment: Alignment.bottomCenter,
            child: RaisedButton(
              child: Text('Scan'),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                gotoCamera(context);
              }),

      ),
      ),
    ),
    );
  }
}



