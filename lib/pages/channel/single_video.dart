import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:line_icons/line_icons.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_iframe/src/player_value.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ytdownload/pages/channel/comments.dart';
import 'package:ytdownload/services/showdownloadlist.dart';
import 'package:ytdownload/widgets/appbar.dart';
import '../../utils/const.dart';

/// channel vids
class SingleVideo extends StatelessWidget {
  /// constractor
  const SingleVideo(
      {Key? key,
      required this.title,
      required this.videoID,
      required this.thumbLow,
      required this.thumbMid,
      required this.thumbHigh,
      required this.id})
      : super(key: key);

  /// title
  final String title;

  /// video ID
  final String videoID;

  ///
  final String thumbLow;

  ///
  final String thumbMid;

  ///
  final String thumbHigh;

  ///
  final VideoId id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.currentTheme(context).baseColor,
      appBar: myAppBar(context, title, isNavBack.yes, isDown.yes, isDispo.no),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlayVideoYT(
            videoID: videoID,
          ),
          NeumorphicButton(
            margin: const EdgeInsets.all(
              20,
            ),
            child: const Text(
              'Show Comments',
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              showCommmentos(
                context,
                videoID,
              );
            },
          ),
        ],
      ),
      floatingActionButton: NeumorphicFloatingActionButton(
        child: Icon(
          Icons.download,
          color: NeumorphicTheme.isUsingDark(context)
              ? Colors.white
              : Colors.black,
        ),
        onPressed: () {
          showDownloadListo(context, title, id, thumbLow, thumbMid, thumbHigh);
        },
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
        /* showControls: true, */
      ),
    );
    /* _controller.onEnterFullscreen = () { */
    /*   SystemChrome.setPreferredOrientations(<DeviceOrientation>[ */
    /*     DeviceOrientation.landscapeLeft, */
    /*     DeviceOrientation.landscapeRight, */
    /*     /* DeviceOrientation.portraitDown, */ */
    /*     /* DeviceOrientation.portraitUp, */ */
    /*   ]); */
    /* }; */
    /* _controller.onExitFullscreen = () { */
    /*   SystemChrome.setPreferredOrientations(<DeviceOrientation>[ */
    /*     DeviceOrientation.portraitDown, */
    /*     DeviceOrientation.portraitUp, */
    /*   ]); */
    /* }; */
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
      child: Column(
        children: <Widget>[
          YoutubePlayerControllerProvider(
            controller: _controller,
            child: Neumorphic(
              padding: const EdgeInsets.all(5),
              style: const NeumorphicStyle(
                shape: NeumorphicShape.concave,
              ),
              child: const YoutubePlayerIFrame(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: YoutubePlayerControllerProvider(
              controller: _controller,
              child: VolumeSlider(),
            ),
          ),
          YoutubePlayerControllerProvider(
            controller: _controller,
            child: PlayPauseButtonBar(),
          ),
        ],
      ),
    );
  }
}

/// volume slider
class VolumeSlider extends StatelessWidget {
  final ValueNotifier<int> _volume = ValueNotifier<int>(100);
  final ValueNotifier<bool> _isMuted = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: _isMuted,
          builder: (BuildContext context, bool isMuted, _) {
            return IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: NeumorphicTheme.isUsingDark(context)
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                _isMuted.value = !isMuted;
                isMuted
                    ? context.ytController.unMute()
                    : context.ytController.mute();
              },
            );
          },
        ),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _volume,
            builder: (BuildContext context, int volume, _) {
              return NeumorphicSlider(
                height: 10,
                value: volume.toDouble(),
                max: 100.0,
                onChanged: (double value) {
                  _volume.value = value.round();
                  context.ytController.setVolume(volume);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

///
class PlayPauseButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        /* IconButton( */
        /*   icon: Icon( */
        /*     Icons.skip_previous, */
        /*     color: NeumorphicTheme.isUsingDark(context) */
        /*         ? Colors.white */
        /*         : Colors.black, */
        /*   ), */
        /*   onPressed: () { */
        /*     context.ytController.listen((YoutubePlayerValue event) { */
        /*       context.ytController.seekTo( */
        /*         event.position - */
        /*             const Duration( */
        /*               seconds: 5, */
        /*             ), */
        /*       ); */
        /*       // event.position */
        /*     }); */
        /*   }, */
        /* ), */
        YoutubeValueBuilder(
          builder: (BuildContext context, YoutubePlayerValue value) {
            return IconButton(
              icon: Icon(
                value.playerState == PlayerState.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: NeumorphicTheme.isUsingDark(context)
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: value.isReady
                  ? () {
                      value.playerState == PlayerState.playing
                          ? context.ytController.pause()
                          : context.ytController.play();
                    }
                  : null,
            );
          },
        ),
        /* IconButton( */
        /*   icon: Icon( */
        /*     Icons.skip_next, */
        /*     color: NeumorphicTheme.isUsingDark(context) */
        /*         ? Colors.white */
        /*         : Colors.black, */
        /*   ), */
        /*   onPressed: () { */
        /*     context.ytController.listen((YoutubePlayerValue event) { */
        /*       context.ytController.seekTo( */
        /*         event.position + */
        /*             const Duration( */
        /*               seconds: 5, */
        /*             ), */
        /*       ); */
        /*       // event.position */
        /*     }); */
        /*   }, */
        /* ), */
        /* IconButton( */
        /*   icon: const Icon(Icons.fullscreen), */
        /*   onPressed: context.ytController.onEnterFullscreen, */
        /* ), */
        /* IconButton( */
        /*   icon: const Icon(Icons.fullscreen_exit), */
        /*   onPressed: context.ytController.onExitFullscreen, */
        /* ), */
      ],
    );
  }
}
