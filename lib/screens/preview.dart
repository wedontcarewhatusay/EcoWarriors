import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:cameraapp/screens/camera.dart';
import 'package:flutter/services.dart';


class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  final Object trackCount;

  PreviewScreen({this.imgPath, this.fileName, this.trackCount});


  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.check,color: Colors.white,),
                      onPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.cancel,color: Colors.white,),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future getBytes () async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}

class ItemsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
      ),
      body: ItemsList(firestore: FirebaseFirestore.instance),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
        },
        child: const Icon(Icons.add),
      ),
      );
  }
}

class ItemsList extends StatelessWidget {
        ItemsList({this.firestore});

        final FirebaseFirestore firestore;

        @override
                Widget build(BuildContext context) {
                        return StreamBuilder<QuerySnapshot>(
                                        stream: firestore.collection('items').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (!snapshot.hasData) return const Text('Loading...');
                                        final int itemsCount = snapshot.data.docs.length;
                                        return ListView.builder(
                                                        itemCount: itemsCount,
                                                        itemBuilder: (_, int index) {
                                                        final DocumentSnapshot document = snapshot.data.docs[index];
                                                        return SafeArea(
                                                                        top: false,
                                                                        bottom: false,
                                                                        child: Container(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                height: 310.0,
                                                                                child: Card(
                                                                                        shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(16.0),
                                                                                                        topRight: Radius.circular(16.0),
                                                                                                        bottomLeft: Radius.circular(16.0),
                                                                                                        bottomRight: Radius.circular(16.0),
                                                                                                        ),
                                                                                                ),
                                                                                        child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: <Widget>[
                                                                                                // photo and title
                                                                                                SizedBox(
                                                                                                        height: 184.0,
                                                                                                        child: Stack(
                                                                                                                children: <Widget>[
                                                                                                                Positioned.fill(
                                                                                                                        child: Image.network(document['downloadURL']),
                                                                                                                        ),
                                                                                                                ],
                                                                                                                ),
                                                                                                        ),
                                                                                                Expanded(
                                                                                                        child: Padding(
                                                                                                                padding:
                                                                                                                const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                                                                                                                child: DefaultTextStyle(
                                                                                                                        softWrap: true,
                                                                                                                        //overflow: TextOverflow.,
                                                                                                                        style: Theme.of(context).textTheme.subhead,
                                                                                                                        child: Column(
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                children: <Widget>[
                                                                                                                                Text(document['labels'].join(', ')),
                                                                                                                                ]),
                                                                                                                        ),
                                                                                                                ),
                                                                                                        ),
                                                                                                ],
                                                                                                ),
                                                                                                ),
                                                                                                ),
                                                                                                );
                                                        },
                                                        );
                                        },
                                        );
                }
}


class InfoScreen extends StatefulWidget {


  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {

    Color color = Theme.of(context).primaryColor;

    Widget textSection = Container(
      padding: const EdgeInsets.all(60),
      child: Center (
      child: Text(
        '''
        You are about to throw away a green glass bottle. If left unrecycled it will more than 3000 years to decompose.  The energy saved from recycling it could power a LED lightbulb for 40hours.
        ''',
        style: TextStyle(fontSize: 20),
        softWrap: true,
      ),
      )
    );

    Widget imageSection = Container(
        child: Align (

          // padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.modulate),
              child: Image.asset('./images/green.png', width: 80, height: 80),
            )
        )
    );


    return MaterialApp(
      home: Scaffold(

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          // child: ListView (
          children: <Widget>[
            textSection,
            imageSection,
            // Image.asset(
            //   './images/green.png',
            //   width: 40,
            //   height: 40,
            // ),
          ],
        // )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Text('Thank you for making the right choice!'),
                )
            );

          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

}