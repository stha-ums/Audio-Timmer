import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import 'file_formats.dart';
import 'storage_dir.dart';
import 'trim_editor.dart';

/// Helps in loading audio from file, saving trimmed audio to a file
/// and gives audio playback controls. Some of the helpful methods
/// are:
/// * [loadaudio()]
/// * [saveTrimmedaudio()]
/// * [videPlaybackControl()]
class Trimmer {
  File currentaudioFile;
  AudioPlayer audioPlayer;
  static Duration currentPlayerPosition;
  static Duration totalDuration;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  /// Loads a audio using the path provided.
  ///
  /// Returns the loaded audio file.
  Future<void> loadaudio({@required File audioFile}) async {
    currentaudioFile = audioFile;
    if (currentaudioFile != null) {
      audioPlayer = AudioPlayer();

      await audioPlayer.setUrl(currentaudioFile.path, isLocal: true);
      await audioPlayer.resume();
      await audioPlayer.getDuration().then((value) {
        print("gg $value");
        print(totalDuration = Duration(milliseconds: value));
      });
      await audioPlayer.pause();

      audioPlayer.onAudioPositionChanged.listen((Duration currentPosition) {
        print("current duration $currentPosition");
        currentPlayerPosition = currentPosition;
      });
    }
  }

  Future<String> _createFolderInAppDocDir(
    String folderName,
    StorageDir storageDir,
  ) async {
    Directory _directory;

    if (storageDir == null) {
      _directory = await getTemporaryDirectory();
    } else {
      switch (storageDir.toString()) {
        case 'temporaryDirectory':
          _directory = await getTemporaryDirectory();
          break;

        case 'applicationDocumentsDirectory':
          _directory = await getApplicationDocumentsDirectory();
          break;

        case 'externalStorageDirectory':
          _directory = await getExternalStorageDirectory();
          break;
      }
    }

    // Directory + folder name
    final Directory _directoryFolder =
        Directory('${_directory.path}/$folderName/');

    if (await _directoryFolder.exists()) {
      // If folder already exists return path
      print('Exists');
      return _directoryFolder.path;
    } else {
      print('Creating');
      // If folder does not exists create folder and then return its path
      final Directory _directoryNewFolder =
          await _directoryFolder.create(recursive: true);
      return _directoryNewFolder.path;
    }
  }

  /// Saves the trimmed audio to file system.
  ///
  /// Returns the output audio path
  ///
  /// The required parameters are [startValue] & [endValue].
  ///
  /// The optional parameters are [audioFolderName], [audioFileName],
  /// [outputFormat], [fpsGIF], [scaleGIF], [applyaudioEncoding].
  ///
  /// The `@required` parameter [startValue] is for providing a starting point
  /// to the trimmed audio. To be specified in `milliseconds`.
  ///
  /// The `@required` parameter [endValue] is for providing an ending point
  /// to the trimmed audio. To be specified in `milliseconds`.
  ///
  /// The parameter [audioFolderName] is used to
  /// pass a folder name which will be used for creating a new
  /// folder in the selected directory. The default value for
  /// it is `Trimmer`.
  ///
  /// The parameter [audioFileName] is used for giving
  /// a new name to the trimmed audio file. By default the
  /// trimmed audio is named as `<original_file_name>_trimmed.mp4`.
  ///
  /// The parameter [outputFormat] is used for providing a
  /// file format to the trimmed audio. This only accepts value
  /// of [FileFormat] type. By default it is set to `FileFormat.mp4`,
  /// which is for `mp4` files.
  ///
  /// The parameter [storageDir] can be used for providing a storage
  /// location option. It accepts only [StorageDir] values. By default
  /// it is set to [applicationDocumentsDirectory]. Some of the
  /// storage types are:
  ///
  /// * [temporaryDirectory] (Only accessible from inside the app, can be
  /// cleared at anytime)
  ///
  /// * [applicationDocumentsDirectory] (Only accessible from inside the app)
  ///
  /// * [externalStorageDirectory] (Supports only `Android`, accessible externally)
  ///
  /// The parameters [fpsGIF] & [scaleGIF] are used only if the
  /// selected output format is `FileFormat.gif`.
  ///
  /// * [fpsGIF] for providing a FPS value (by default it is set
  /// to `10`)
  ///
  ///
  /// * [scaleGIF] for proving a width to output GIF, the height
  /// is selected by maintaining the aspect ratio automatically (by
  /// default it is set to `480`)
  ///
  ///
  /// * [applyaudioEncoding] for specifying whether to apply audio
  /// encoding (by default it is set to `false`).
  ///
  ///
  /// ADVANCED OPTION:
  ///
  /// If you want to give custom `FFmpeg` command, then define
  /// [ffmpegCommand] & [customaudioFormat] strings. The `input path`,
  /// `output path`, `start` and `end` position is already define.
  ///
  /// NOTE: The advanced option does not provide any safety check, so if wrong
  /// audio format is passed in [customaudioFormat], then the app may
  /// crash.
  ///
  Future<String> saveTrimmedaudio({
    @required Duration startPoint,
    @required Duration endPoint,
    bool applyaudioEncoding = false,
    FileFormat outputFormat,
    String ffmpegCommand,
    String customaudioFormat,
    int fpsGIF,
    int scaleGIF,
    String audioFolderName,
    String audioFileName,
    StorageDir storageDir,
  }) async {
    final String _audioPath = currentaudioFile.path;
    final String _audioName = basename(_audioPath).split('.')[0];

    String _command;

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    // String _resultString;
    String _outputPath;
    String _outputFormatString;
    String formattedDateTime = dateTime.replaceAll(' ', '');

    print("DateTime: $dateTime");
    print("Formatted: $formattedDateTime");

    if (audioFolderName == null) {
      audioFolderName = "Trimmer";
    }

    if (audioFileName == null) {
      audioFileName = "${_audioName}_trimmed:$formattedDateTime";
    }

    audioFileName = audioFileName.replaceAll(' ', '_');

    String path = await _createFolderInAppDocDir(
      audioFolderName,
      storageDir,
    ).whenComplete(
      () => print("Retrieved Trimmer folder"),
    );

    // Checking the start and end point strings
    print("Start: ${startPoint.toString()} & End: ${endPoint.toString()}");

    print(path);

    if (outputFormat == null) {
      outputFormat = FileFormat.mp3;
      _outputFormatString = outputFormat.toString();
      print('OUTPUT: $_outputFormatString');
    } else {
      _outputFormatString = outputFormat.toString();
    }

    String _trimLengthCommand =
        ' -ss $startPoint -i "$_audioPath" -t ${endPoint - startPoint} -avoid_negative_ts make_zero ';

    if (ffmpegCommand == null) {
      _command = '$_trimLengthCommand -c:a copy ';

      if (!applyaudioEncoding) {
        _command += '-c:v copy ';
      }

      // if (outputFormat == FileFormat.gif) {
      //   if (fpsGIF == null) {
      //     fpsGIF = 10;
      //   }
      //   if (scaleGIF == null) {
      //     scaleGIF = 480;
      //   }
      //   _command =
      //       '$_trimLengthCommand -vf "fps=$fpsGIF,scale=$scaleGIF:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 ';
      // }
    } else {
      _command = '$_trimLengthCommand $ffmpegCommand ';
      _outputFormatString = customaudioFormat;
    }

    _outputPath = '$path$audioFileName$_outputFormatString';

    _command += '"$_outputPath"';

    await _flutterFFmpeg.execute(_command).whenComplete(() {
      print('Got value');
      debugPrint('Audio successfuly saved');
      // _resultString = 'Audio successfuly saved';
    }).catchError((error) {
      print('Error');
      // _resultString = 'Couldn\'t save the audio';
      debugPrint('Couldn\'t save the audio');
    });

    return _outputPath;
  }

  /// For getting the audio controller state, to know whether the
  /// audio is playing or paused currently.
  ///
  /// The two required parameters are [startValue] & [endValue]
  ///
  /// * [startValue] is the current starting point of the audio.
  /// * [endValue] is the current ending point of the audio.
  ///
  /// Returns a `Future<bool>`, if `true` then audio is playing
  /// otherwise paused.
  Future<bool> videPlaybackControl({
    @required double startValue,
    @required double endValue,
  }) async {
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      await audioPlayer.pause();
      return false;
    } else {
      currentPlayerPosition =
          currentPlayerPosition ?? await audioPlayer.getCurrentPosition();

      if (currentPlayerPosition.inMilliseconds >= endValue.toInt()) {
        await audioPlayer.seek(Duration(milliseconds: startValue.toInt()));
        await audioPlayer.resume();
        return true;
      } else {
        await audioPlayer.resume();
        return true;
      }
    }
  }

  File getaudioFile() {
    return currentaudioFile;
  }
}
