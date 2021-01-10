import 'package:audio_trimmer/audio_trimmer.dart';
import 'package:flutter/material.dart';

class TrimmerView extends StatefulWidget {
  final Trimmer _trimmer;
  TrimmerView(this._trimmer);
  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  double _startValue;
  double _endValue;

  // bool _isPlaying = false;
  // bool _progressVisibility = false;

  Future<String> _saveaudio() async {
    setState(() {
      // _progressVisibility = true;
    });

    String _value;
    print(" saving =>");
    print("saving => $_startValue");
    print("saving => $_endValue");
    if (_endValue == 0) {
      return widget._trimmer.currentaudioFile.path;
    }
    await widget._trimmer
        .saveTrimmedaudio(
            startPoint: Duration(milliseconds: _startValue.toInt()),
            endPoint: Duration(milliseconds: _endValue.toInt()))
        .then((value) {
      setState(() {
        // _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SafeArea(
              child: Builder(
                builder: (context) => Center(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          // height: 20,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),

                                  // return the starting and endig of the audio for later trimming
                                  InkWell(
                                    onTap: () async {
                                      var fs = await _saveaudio();
                                      print(fs);
                                      // Navigator.pop(
                                      //     context, [_startValue, _endValue]);
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: audioViewer(
                        //       audioPlayerController:
                        //           widget._trimmer.audioPlayerController,
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: TrimEditor(
                            startTime: _startValue,
                            endTime: _endValue,
                            onHorizontalDragEnd: (start, end) =>
                                {_startValue = start, _endValue = end},
                            audioFile: widget._trimmer.currentaudioFile,
                            audioPlayer: widget._trimmer.audioPlayer,
                            viewerHeight: 50.0,
                            viewerWidth: MediaQuery.of(context).size.width,
                            maxaudioLength: Trimmer.totalDuration,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
