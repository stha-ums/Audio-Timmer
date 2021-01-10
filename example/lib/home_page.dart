import 'dart:io';

import 'package:audio_trimmer/audio_trimmer.dart';
import 'package:audio_trimmer_example/trimmer_view.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Trimmer _trimmer = Trimmer();
  String outputPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Trimmer"),
      ),
      body: ListView(
        children: [
          RaisedButton(
            child: Text("LOAD audio"),
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path);
                print(file.path);
                await _trimmer.loadaudio(audioFile: file);
                outputPath = null;
                setState(() {});
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(_trimmer);
                  }),
                );
                setState(() {});
              }
            },
          ),
          // if (outputPath != null)
          //   Container(height: 500, child: Preview(outputPath))
        ],
      ),
    );
  }
}
