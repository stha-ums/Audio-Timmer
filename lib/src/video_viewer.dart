// import 'package:flutter/material.dart';
// import 'package:audio_player/audio_player.dart';

// class audioViewer extends StatefulWidget {
//   /// For specifying the color of the audio
//   /// viewer area border. By default it is set to `Colors.transparent`.
//   final Color borderColor;

//   final audioPlayerController audioPlayerController;

//   /// For specifying the border width around
//   /// the audio viewer area. By default it is set to `0.0`.
//   final double borderWidth;

//   /// For specifying a padding around the audio viewer
//   /// area. By default it is set to `EdgeInsets.all(0.0)`.
//   final EdgeInsets padding;

//   /// For showing the audio playback area.
//   ///
//   /// This only contains optional parameters. They are:
//   ///
//   /// * [borderColor] for specifying the color of the audio
//   /// viewer area border. By default it is set to `Colors.transparent`.
//   ///
//   ///
//   /// * [borderWidth] for specifying the border width around
//   /// the audio viewer area. By default it is set to `0.0`.
//   ///
//   ///
//   /// * [padding] for specifying a padding around the audio viewer
//   /// area. By default it is set to `EdgeInsets.all(0.0)`.
//   ///
//   audioViewer({
//     this.borderColor = Colors.transparent,
//     this.borderWidth = 0.0,
//     this.padding = const EdgeInsets.all(0.0),
//     this.audioPlayerController,
//   });

//   @override
//   _audioViewerState createState() => _audioViewerState();
// }

// class _audioViewerState extends State<audioViewer> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: widget.padding,
//         child: AspectRatio(
//           aspectRatio: widget.audioPlayerController.value.aspectRatio,
//           child: widget.audioPlayerController.value.initialized
//               ? Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: widget.borderWidth,
//                       color: widget.borderColor,
//                     ),
//                   ),
//                   child: audioPlayer(widget.audioPlayerController),
//                 )
//               : Container(
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
