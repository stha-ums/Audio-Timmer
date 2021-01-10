// import 'dart:io';
// import 'package:flutter/material.dart';
// class Preview extends StatefulWidget {
//   final String outputaudioPath;

//   Preview(this.outputaudioPath);

//   @override
//   _PreviewState createState() => _PreviewState();
// }

// class _PreviewState extends State<Preview> {
//   audioPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = audioPlayerController.file(File(widget.outputaudioPath))
//       ..initialize().then((_) async {
//         setState(() {});
//         await _controller.setLooping(true);
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: _controller.value.initialized
//             ? Container(
//                 child: audioPlayer(_controller),
//               )
//             : Container(
//                 child: Center(
//                   child: CircularProgressIndicator(
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
