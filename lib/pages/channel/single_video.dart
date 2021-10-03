import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ytdownload/widgets/appbar.dart';
import '../../utils/const.dart';

/// channel vids
class SingleVideo extends StatelessWidget {
  /// constractor
  const SingleVideo({Key? key, required this.title, required this.videoID})
      : super(key: key);

  /// title
  final String title;

  /// video ID
  final String videoID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, title, isNavBack.yes, isDown.yes, isDispo.no),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlayVideoYT(
            videoID: videoID,
          ),
          NeumorphicButton(
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            child: const Text('Show Comments'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

/// video player for youtube
class PlayVideoYT extends StatefulWidget {
  /// constractor
  const PlayVideoYT({Key? key, required this.videoID}) : super(key: key);

  /// video id from parent widget
  final String videoID;

  @override
  _PlayVideoYTState createState() => _PlayVideoYTState();
}

class _PlayVideoYTState extends State<PlayVideoYT> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {};
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  // final YoutubePlayerController
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.all(8),
      child: YoutubePlayerIFrame(
        controller: _controller,
        // gestureRecognizers: ,
        // aspectRatio: 16 / 9,
      ),
    );
  }
}
