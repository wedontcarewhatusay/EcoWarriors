import 'package:flutter/material.dart';
import 'package:cameraapp/screens/camera.dart';


class HomeScreen extends StatelessWidget {

  gotoCamera(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Activity Screen'),
      ),
      body: Center(

        child: RaisedButton(
            child: Text('Navigate To Second Screen'),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              gotoCamera(context);
            }),

      ),
    );
  }
}



