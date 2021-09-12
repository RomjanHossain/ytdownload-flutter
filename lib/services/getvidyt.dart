// import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// get videos from youtube
class GetVideosFromYT extends ChangeNotifier {
  /// yt explode
  YoutubeExplode yt = YoutubeExplode();

  /// ;lsat ivd
  late SearchList lastVid;

  /// last vid
  late ChannelUploadsList lastchannelvid;

  /// future vid
  Future<List<Video>> forfuture() async {
    return myListssss;
  }

  /// future vid
  Future<List<Video>> futurechannelvideos() async {
    return myListforchannel;
  }

  /// playlist
  Future<List<Video>> forfutureListoVideos(String qq) async {
    final List<Video> _mm = <Video>[];
    await yt.playlists.get(qq).then((Playlist value) async {
      await for (final Video video in yt.playlists.getVideos(value.id)) {
        _mm.add(video);
        /* video.duration */
      }
    });
    return _mm;
  }

  /// playlist
  Future<void> forfutureChannelVideos(String qq) async {
    yt.channels.getUploadsFromPage(qq).then((ChannelUploadsList value2) {
      /* value2.nextPage(); */
      for (final Video video in value2) {
        /* _mm.add(video); */
        myListforchannel.add(video);
        /* print('adding function->${video.title}'); */
      }
      lastchannelvid = value2;
    });

    /* notifyListeners(); */
    /* return _mm; */
  }

  ///playlist-info
  Future<Playlist> forfutureListoInfo(String keyword) async {
    late Playlist _p;
    await yt.playlists.get(keyword).then((Playlist value) {
      _p = value;
    });
    return _p;
  }

  /// playlst video

  /// Isdafsd
  List<Video> myListssss = <Video>[];

  /// Isdafsd
  List<Video> myListforchannel = <Video>[];

  /// ilst of all vides
  Future<void> listoVideos(String keyword) async {
    await yt.search.getVideos(keyword).then((SearchList value) {
      for (final Video i in value) {
        myListssss.add(i);
        /* print('#done ${i.title}'); */
      }
      lastVid = value;
    });
    notifyListeners();
  }

  /// next videso
  Future<void> nextVideos() async {
    lastVid.nextPage().then((SearchList? value) {
      if (value!.isNotEmpty) {
        for (final Video item in value) {
          myListssss.add(item);
          /* print('#done ${item.title}'); */
        }
        lastVid = value;
      }
    });

    notifyListeners();
  }

  /// next videso from channel
  Future<void> nextVideosFromChannel() async {
    lastchannelvid.nextPage().then((ChannelUploadsList? value) {
      if (value!.isNotEmpty) {
        for (final Video item in value) {
          myListforchannel.add(item);
          /* print('#done ${item.title}'); */
        }
        lastchannelvid = value;
      }
    });

    notifyListeners();
  }

  /// this is should go in future
  void dispoo() {
    /* print('disoooooooooooo'); */
    myListssss = <Video>[];
    myListforchannel = <Video>[];
    /* if (lastVid.isNotEmpty) {} */
    notifyListeners();
  }
}
