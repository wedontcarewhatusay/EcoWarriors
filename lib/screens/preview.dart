import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:cameraapp/screens/camera.dart';


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
