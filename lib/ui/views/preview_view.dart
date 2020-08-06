import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// import flutter services
import 'package:flutter/services.dart';

class PreviewImageScreen extends StatefulWidget {
  final String imagePath;

  PreviewImageScreen({this.imagePath});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.file(File(widget.imagePath), fit: BoxFit.cover)),
            SizedBox(height: 10.0),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: RaisedButton(
                  onPressed: null,
//                  () {
//                    getBytesFromFile().then((bytes) {
//                      Share.file('Share via:', basename(widget.imagePath),
//                          bytes.buffer.asUint8List(), 'image/png');
//                    });
//                  },
                  child: Text('Share'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}
