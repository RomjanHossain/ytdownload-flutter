import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ytdownload/models/ytmodel.dart';

/// my ytd model
class YoutubeDownloadProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<YoutubeDownloadModel> _iitems = <YoutubeDownloadModel>[];

  ///full videosjfds
  final List<YoutubeDownloadModel> _fulllvideos = <YoutubeDownloadModel>[];

  /// videos
  final List<YoutubeDownloadModel> _videos = <YoutubeDownloadModel>[];

  /// phots
  final List<YoutubeDownloadModel> _photos = <YoutubeDownloadModel>[];

  /// audios
  final List<YoutubeDownloadModel> _audios = <YoutubeDownloadModel>[];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<YoutubeDownloadModel> get items =>
      UnmodifiableListView<YoutubeDownloadModel>(_iitems);

  /// videos
  UnmodifiableListView<YoutubeDownloadModel> get videos =>
      UnmodifiableListView<YoutubeDownloadModel>(_videos);

  /// photos
  UnmodifiableListView<YoutubeDownloadModel> get photos =>
      UnmodifiableListView<YoutubeDownloadModel>(_photos);

  /// audios
  UnmodifiableListView<YoutubeDownloadModel> get fullvideos =>
      UnmodifiableListView<YoutubeDownloadModel>(_fulllvideos);

  /// audios
  UnmodifiableListView<YoutubeDownloadModel> get audios =>
      UnmodifiableListView<YoutubeDownloadModel>(_audios);

  /// The current total price of all items (assuming all items cost $42).
  int get downloadsyt => _iitems.length;

  /// total download
  int get totalDownload =>
      _audios.length +
      _videos.length +
      _photos.length +
      _fulllvideos.length +
      _iitems.length;

  /// progress bar
  /* List<double> prog = <double>[]; */

  /// url
  /* List<String> url = <String>[]; */

  /// path+name
  /* List<String> pathName = <String>[]; */

  /// from the outside.
  void addThumbnail(YoutubeDownloadModel item) {
    _photos.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// add video noly
  void addOnlyVideo(YoutubeDownloadModel item) {
    _videos.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// add full-videosj

  void addFullvideoaudio(YoutubeDownloadModel item) {
    _fulllvideos.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// add audio only
  void additem(YoutubeDownloadModel item) {
    _iitems.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// add audio only
  void addaudio(YoutubeDownloadModel item) {
    _audios.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the
  void removeAll() {
    _iitems.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
