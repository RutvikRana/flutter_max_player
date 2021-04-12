import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_world/videoView.dart';

void main() => runApp(MyApp());

// ------ Root Widget ---------
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Example",
      theme: ThemeData(
          primarySwatch: Colors.green,
          canvasColor: Colors.blue.shade100,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          platform: TargetPlatform.android),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Max Player Example"),),
      body: Center(
          child: 
            Padding(
              padding: EdgeInsets.all(10),
              child: 
                Container(
                  child: 
                    VideoView("/storage/emulated/0/Download/b.mp4",
                      sourceType: SourceType.File,
                      title: Text("Big Buck Bunny",style: TextStyle(fontSize: 20),)
                    ),
              )
            )
          ),
    );
  }
}