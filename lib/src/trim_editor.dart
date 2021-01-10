import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'trim_editor_painter.dart';
import 'trimmer.dart';

// audioPlayerController _audioPlayer;



class TrimEditor extends StatefulWidget {
  /// For defining the total trimmer area width
  final double viewerWidth;

  //predefined start time

  final double startTime;

  //predefined end time

  final double endTime;

  //for the thumbnailgeneration
  final File audioFile;

  // the editing audio controller
  final AudioPlayer audioPlayer;

  // the editin video

  /// For defining the total trimmer area height
  final double viewerHeight;

  /// For defining the image fit type of each thumbnail image.
  ///
  /// By default it is set to `BoxFit.fitHeight`.
  final BoxFit fit;

  /// For defining the maximum length of the output audio.
  final Duration maxaudioLength;

  /// For specifying a size to the holder at the
  /// two ends of the audio trimmer area, while it is `idle`.
  ///
  /// By default it is set to `5.0`.
  final double circleSize;

  /// For specifying a size to the holder at
  /// the two ends of the audio trimmer area, while it is being
  /// `dragged`.
  ///
  /// By default it is set to `8.0`.
  final double circleSizeOnDrag;

  /// For specifying a color to the circle.
  ///
  /// By default it is set to `Colors.white`.
  final Color circlePaintColor;

  /// For specifying a color to the border of
  /// the trim area.
  ///
  /// By default it is set to `Colors.white`.
  final Color borderPaintColor;

  /// For specifying a color to the audio
  /// scrubber inside the trim area.
  ///
  /// By default it is set to `Colors.white`.
  final Color scrubberPaintColor;

  /// For specifying the quality of each
  /// generated image thumbnail, to be displayed in the trimmer
  /// area.
  final int thumbnailQuality;

  /// For showing the start and the end point of the
  /// audio on top of the trimmer area.
  ///
  /// By default it is set to `true`.
  final bool showDuration;

  /// For providing a `TextStyle` to the
  /// duration text.
  ///
  /// By default it is set to `TextStyle(color: Colors.white)`
  final TextStyle durationTextStyle;

  /// Callback to the audio start position
  ///
  /// Returns the selected audio start position in `milliseconds`.
  final Function(double startValue) onChangeStart;

  /// Callback to the audio end position.
  ///
  /// Returns the selected audio end position in `milliseconds`.
  final Function(double endValue) onChangeEnd;

  /// Callback to the audio playback
  /// state to know whether it is currently playing or paused.
  ///
  /// Returns a `boolean` value. If `true`, audio is currently
  /// playing, otherwise paused.
  final Function(bool isPlaying) onChangePlaybackState;

  final Function(double startPosition, double endPosition) onHorizontalDragEnd;

  /// Widget for displaying the audio trimmer.
  ///
  /// This has frame wise preview of the audio with a
  /// slider for selecting the part of the audio to be
  /// trimmed.
  ///
  /// The required parameters are [viewerWidth] & [viewerHeight]
  ///
  /// * [viewerWidth] to define the total trimmer area width.
  ///
  ///
  /// * [viewerHeight] to define the total trimmer area height.
  ///
  ///
  /// The optional parameters are:
  ///
  /// * [fit] for specifying the image fit type of each thumbnail image.
  /// By default it is set to `BoxFit.fitHeight`.
  ///
  ///
  /// * [maxaudioLength] for specifying the maximum length of the
  /// output audio.
  ///
  ///
  /// * [circleSize] for specifying a size to the holder at the
  /// two ends of the audio trimmer area, while it is `idle`.
  /// By default it is set to `5.0`.
  ///
  ///
  /// * [circleSizeOnDrag] for specifying a size to the holder at
  /// the two ends of the audio trimmer area, while it is being
  /// `dragged`. By default it is set to `8.0`.
  ///
  ///
  /// * [circlePaintColor] for specifying a color to the circle.
  /// By default it is set to `Colors.white`.
  ///
  ///
  /// * [borderPaintColor] for specifying a color to the border of
  /// the trim area. By default it is set to `Colors.white`.
  ///
  ///
  /// * [scrubberPaintColor] for specifying a color to the audio
  /// scrubber inside the trim area. By default it is set to
  /// `Colors.white`.
  ///
  ///
  /// * [thumbnailQuality] for specifying the quality of each
  /// generated image thumbnail, to be displayed in the trimmer
  /// area.
  ///
  ///
  /// * [showDuration] for showing the start and the end point of the
  /// audio on top of the trimmer area. By default it is set to `true`.
  ///
  ///
  /// * [durationTextStyle] is for providing a `TextStyle` to the
  /// duration text. By default it is set to
  /// `TextStyle(color: Colors.white)`
  ///
  ///
  /// * [onChangeStart] is a callback to the audio start position.
  ///
  ///
  /// * [onChangeEnd] is a callback to the audio end position.
  ///
  ///
  /// * [onChangePlaybackState] is a callback to the audio playback
  /// state to know whether it is currently playing or paused.
  ///
  TrimEditor({
    @required this.viewerWidth,
    @required this.viewerHeight,
    this.fit = BoxFit.fitHeight,
    this.maxaudioLength = const Duration(milliseconds: 0),
    this.circleSize = 5.0,
    this.circleSizeOnDrag = 8.0,
    this.circlePaintColor = Colors.white,
    this.borderPaintColor = Colors.white,
    this.scrubberPaintColor = Colors.white,
    this.thumbnailQuality = 40,
    this.showDuration = true,
    this.durationTextStyle = const TextStyle(
      color: Colors.white,
    ),
    this.onChangeStart,
    this.onChangeEnd,
    this.onChangePlaybackState,
    @required this.audioPlayer,
    @required this.audioFile,
    this.onHorizontalDragEnd,
    this.startTime,
    this.endTime,
  })  : assert(viewerWidth != null),
        assert(viewerHeight != null),
        assert(fit != null),
        assert(maxaudioLength != null),
        assert(circleSize != null),
        assert(circleSizeOnDrag != null),
        assert(circlePaintColor != null),
        assert(borderPaintColor != null),
        assert(scrubberPaintColor != null),
        assert(thumbnailQuality != null),
        assert(showDuration != null),
        assert(durationTextStyle != null);

  @override
  _TrimEditorState createState() => _TrimEditorState();
}

class _TrimEditorState extends State<TrimEditor> with TickerProviderStateMixin {
  File _audioFile;

  double _audioStartPos = 0.0;
  double _audioEndPos = 0.0;

  bool _canUpdateStart = true;
  bool _isLeftDrag = true;

  Offset _startPos = Offset(0, 0);
  Offset _endPos = Offset(0, 0);

  double _startFraction = 0.0;
  double _endFraction = 1.0;

  int _audioDuration = 0;
  int _currentPosition = 0;

  double _thumbnailViewerW = 0.0;
  double _thumbnailViewerH = 0.0;

  int _numberOfThumbnails = 0;

  double _circleSize;

  double fraction;
  double maxLengthPixels;

  // ThumbnailViewer thumbnailWidget;

  Animation<double> _scrubberAnimation;
  AnimationController _animationController;
  bool _isAnimationControllerDisposed = false;
  Tween<double> _linearTween;

  AudioPlayer _audioPlayer;

  Future<void> _initializeaudioController() async {
    Function audioListner = () {
      final bool isPlaying = _audioPlayer.state == AudioPlayerState.PLAYING;
      print("audio playing: $isPlaying");
      if (isPlaying) {
        if (widget.onChangePlaybackState != null)
          widget.onChangePlaybackState(true);
        if (mounted)
          _currentPosition = Trimmer.currentPlayerPosition == null
              ? 0
              : Trimmer.currentPlayerPosition.inMilliseconds;

        if (_currentPosition > _audioEndPos.toInt()) {
          // print(
          //     "audio playing: ${_currentPosition > _audioEndPos.toInt()} stop condition ");

          if (widget.onChangePlaybackState != null)
            widget.onChangePlaybackState(false);
          _audioPlayer.pause();
          _animationController.stop();
        } else {
          //print("audio playing: animation duarion check ");
          if (_animationController != null &&
              _isAnimationControllerDisposed ==
                  false) if (!_animationController.isAnimating) {
            //print("audio playing: animation stopped ");

            if (widget.onChangePlaybackState != null)
              widget.onChangePlaybackState(true);
            //print(_animationController.duration);
            _animationController.forward();
          }
        }
        setState(() {});
      } else {
        //print("audio playing: check if initialized ");

        if (_audioPlayer != null) {
          if (_animationController != null &&
              _isAnimationControllerDisposed == false) {
            //print("audio playing: animation controller initialize");

            if ((_scrubberAnimation.value).toInt() == (_endPos.dx).toInt()) {
              _animationController.reset();
              // _animationController.forward();
            }
            _animationController.forward();
            videPlaybackControl(
                startValue: _audioStartPos, endValue: _audioEndPos);

            // if (widget.onChangePlaybackState != null)
            // widget.onChangePlaybackState(false);
          }
        }
      }
    };

    if (_audioFile != null) {
      _audioPlayer.onPlayerStateChanged.listen((event) {
        audioListner();
      });
      _audioPlayer.onAudioPositionChanged.listen((_) {
        audioListner();
      });

      _audioPlayer.setVolume(1.0);
      _audioDuration = Trimmer.totalDuration.inMilliseconds;
      //print(_audioFile.path);
      _audioPlayer.resume();
      _audioEndPos = fraction != null
          ? _audioDuration.toDouble() * fraction
          : _audioDuration.toDouble();

      if (widget.onChangeEnd != null) widget.onChangeEnd(_audioEndPos);

      // final ThumbnailViewer _thumbnailWidget = ThumbnailViewer(
      //   audioFile: _audioFile,
      //   audioDuration: _audioDuration,
      //   fit: widget.fit ?? BoxFit.fill,
      //   thumbnailHeight: _thumbnailViewerH,
      //   numberOfThumbnails: _numberOfThumbnails,
      //   quality: widget.thumbnailQuality,
      // );
      // thumbnailWidget = _thumbnailWidget;
    }
  }

  Future<bool> videPlaybackControl({
    @required double startValue,
    @required double endValue,
  }) async {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
      await _audioPlayer.pause();
      return false;
    } else {
      Trimmer.currentPlayerPosition = Trimmer.currentPlayerPosition ??
          await _audioPlayer.getCurrentPosition();

      if (Trimmer.currentPlayerPosition.inMilliseconds >= endValue.toInt()) {
        await _audioPlayer.seek(Duration(milliseconds: startValue.toInt()));
        await _audioPlayer.resume();
        return true;
      } else {
        await _audioPlayer.resume();
        return true;
      }
    }
  }

  void _setaudioStartPosition(DragUpdateDetails details) async {
    if (!(_startPos.dx + details.delta.dx < 0) &&
        !(_startPos.dx + details.delta.dx > _thumbnailViewerW) &&
        !(_startPos.dx + details.delta.dx > _endPos.dx)) {
      if (maxLengthPixels != null) {
        if (!(_endPos.dx - _startPos.dx - details.delta.dx > maxLengthPixels)) {
          if (mounted)
            setState(() {
              if (!(_startPos.dx + details.delta.dx < 0))
                _startPos += details.delta;

              _startFraction = (_startPos.dx / _thumbnailViewerW);

              _audioStartPos = _audioDuration * _startFraction;
              if (widget.onChangeStart != null)
                widget.onChangeStart(_audioStartPos);
            });
          await _audioPlayer.pause();
          await _audioPlayer
              .seek(Duration(milliseconds: _audioStartPos.toInt()));
          _linearTween.begin = _startPos.dx;
          _animationController.duration =
              Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
          _animationController.reset();
        }
      } else {
        if (mounted)
          setState(() {
            if (!(_startPos.dx + details.delta.dx < 0))
              _startPos += details.delta;

            _startFraction = (_startPos.dx / _thumbnailViewerW);

            _audioStartPos = _audioDuration * _startFraction;
            if (widget.onChangeStart != null)
              widget.onChangeStart(_audioStartPos);
          });
        await _audioPlayer.pause();
        await _audioPlayer.seek(Duration(milliseconds: _audioStartPos.toInt()));
        _linearTween.begin = _startPos.dx;
        _animationController.duration =
            Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
        _animationController.reset();
      }
    }
  }

  void _setaudioEndPosition(DragUpdateDetails details) async {
    if (!(_endPos.dx + details.delta.dx > _thumbnailViewerW) &&
        !(_endPos.dx + details.delta.dx < 0) &&
        !(_endPos.dx + details.delta.dx < _startPos.dx)) {
      if (maxLengthPixels != null) {
        if (!(_endPos.dx - _startPos.dx + details.delta.dx > maxLengthPixels)) {
          if (mounted)
            setState(() {
              _endPos += details.delta;
              _endFraction = _endPos.dx / _thumbnailViewerW;

              _audioEndPos = _audioDuration * _endFraction;

              if (widget.onChangeEnd != null) widget.onChangeEnd(_audioEndPos);
            });
          await _audioPlayer.pause();
          await _audioPlayer.seek(Duration(milliseconds: _audioEndPos.toInt()));
          _linearTween.end = _endPos.dx;
          _animationController.duration =
              Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
          _animationController.reset();
        }
      } else {
        if (mounted)
          setState(() {
            _endPos += details.delta;
            _endFraction = _endPos.dx / _thumbnailViewerW;

            _audioEndPos = _audioDuration * _endFraction;

            if (widget.onChangeEnd != null) widget.onChangeEnd(_audioEndPos);
          });
        await _audioPlayer.pause();
        await _audioPlayer.seek(Duration(milliseconds: _audioEndPos.toInt()));
        _linearTween.end = _endPos.dx;
        _animationController.duration =
            Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt());
        _animationController.reset();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayer;

    _audioStartPos = widget.startTime ?? _audioStartPos;
    _audioEndPos = widget.endTime ?? _audioEndPos;
    _circleSize = widget.circleSize;

    _audioFile = widget.audioFile;
    _thumbnailViewerH = widget.viewerHeight;

    _numberOfThumbnails = widget.viewerWidth ~/ _thumbnailViewerH;

    _thumbnailViewerW = _numberOfThumbnails * _thumbnailViewerH;

    Duration totalDuration = Trimmer.totalDuration;

    if (widget.maxaudioLength > Duration(milliseconds: 0) &&
        widget.maxaudioLength <= totalDuration) {
      if (widget.maxaudioLength <= totalDuration) {
        fraction =
            widget.maxaudioLength.inMilliseconds / totalDuration.inMilliseconds;

        maxLengthPixels = _thumbnailViewerW * fraction;
      }
    }

    _initializeaudioController();
    _endPos = Offset(
      maxLengthPixels != null ? maxLengthPixels : _thumbnailViewerW,
      _thumbnailViewerH,
    );

    // Defining the tween points
    _linearTween = Tween(begin: _startPos.dx, end: _endPos.dx);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_audioEndPos - _audioStartPos).toInt()),
    );

    _scrubberAnimation = _linearTween.animate(_animationController)
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.stop();
        }
      });
  }

  @override
  void dispose() {
    _isAnimationControllerDisposed = true;
    _animationController.dispose();

    // _animationController.dispose();

    _audioPlayer.pause();
    if (widget.onChangePlaybackState != null)
      widget.onChangePlaybackState(false);
    if (_audioFile != null) {
      _audioPlayer.setVolume(0.0);
      _audioPlayer.pause();
      _audioPlayer.dispose();
      if (widget.onChangePlaybackState != null)
        widget.onChangePlaybackState(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        //print("START");
        //print(details.localPosition);
        //print((_startPos.dx - details.localPosition.dx).abs());
        //print((_endPos.dx - details.localPosition.dx).abs());

        if (_endPos.dx >= _startPos.dx) {
          if ((_startPos.dx - details.localPosition.dx).abs() >
              (_endPos.dx - details.localPosition.dx).abs()) {
            if (mounted)
              setState(() {
                _canUpdateStart = false;
              });
          } else {
            if (mounted)
              setState(() {
                _canUpdateStart = true;
              });
          }
        } else {
          if (_startPos.dx > details.localPosition.dx) {
            _isLeftDrag = true;
          } else {
            _isLeftDrag = false;
          }
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (mounted)
          setState(() {
            _circleSize = widget.circleSize;
          });
        if (widget.onHorizontalDragEnd != null)
          widget.onHorizontalDragEnd(_audioStartPos, _audioEndPos);
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _circleSize = widget.circleSizeOnDrag;

        print("=>>> ${details.localPosition} update");
        if (_endPos.dx >= _startPos.dx) {
          _isLeftDrag = false;
          if (_canUpdateStart && _startPos.dx + details.delta.dx > 0) {
            _isLeftDrag = false; // To prevent from scrolling over
            _setaudioStartPosition(details);
          } else if (!_canUpdateStart &&
              _endPos.dx + details.delta.dx < _thumbnailViewerW) {
            _isLeftDrag = true; // To prevent from scrolling over
            _setaudioEndPosition(details);
          }
        } else {
          if (_isLeftDrag && _startPos.dx + details.delta.dx > 0) {
            _setaudioStartPosition(details);
          } else if (!_isLeftDrag &&
              _endPos.dx + details.delta.dx < _thumbnailViewerW) {
            _setaudioEndPosition(details);
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.showDuration
              ? Container(
                  width: _thumbnailViewerW,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          Duration(milliseconds: _audioStartPos.toInt())
                              .toString()
                              .split('.')[0],
                          style: widget.durationTextStyle,
                        ),
                        Text(
                          Duration(milliseconds: _audioEndPos.toInt())
                              .toString()
                              .split('.')[0],
                          style: widget.durationTextStyle,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          CustomPaint(
            foregroundPainter: TrimEditorPainter(
              startPos: _startPos,
              endPos: _endPos,
              scrubberAnimationDx: _scrubberAnimation.value,
              circleSize: _circleSize,
              circlePaintColor: widget.circlePaintColor,
              borderPaintColor: widget.borderPaintColor,
              scrubberPaintColor: widget.scrubberPaintColor,
            ),
            child: Container(
              color: Colors.grey[900],
              height: _thumbnailViewerH,
              width: _thumbnailViewerW,
              child: Text(""),
            ),
          ),
        ],
      ),
    );
  }
}
