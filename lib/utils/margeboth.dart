import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// get both videos and audios
Future<void> margeBoth(
  BuildContext context,
  String name,
  String video,
  String audio,
) async {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  _flutterFFmpeg.execute('-i $video -i $audio -c copy $name.mp4').then(
    (int d) {
      print('Return code $d');
      ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('File Have been marged'),
                              ),
                            );
    },
  );
}
