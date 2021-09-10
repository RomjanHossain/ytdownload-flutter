import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ytdownload/models/ytmodel.dart';

/// my ytd model
class YoutubeDownloadProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<YoutubeDownloadModel> _items = <YoutubeDownloadModel>[];

  /// videos
  final List<YoutubeDownloadModel> _videos = <YoutubeDownloadModel>[];

  /// phots
  final List<YoutubeDownloadModel> _photos = <YoutubeDownloadModel>[];

  /// audios
  final List<YoutubeDownloadModel> _audios = <YoutubeDownloadModel>[];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<YoutubeDownloadModel> get items =>
      UnmodifiableListView<YoutubeDownloadModel>(_items);

  /// videos
  UnmodifiableListView<YoutubeDownloadModel> get videos =>
      UnmodifiableListView<YoutubeDownloadModel>(_videos);

  /// photos
  UnmodifiableListView<YoutubeDownloadModel> get photos =>
      UnmodifiableListView<YoutubeDownloadModel>(_photos);

  /// audios
  UnmodifiableListView<YoutubeDownloadModel> get audios =>
      UnmodifiableListView<YoutubeDownloadModel>(_audios);

  /// The current total price of all items (assuming all items cost $42).
  int get downloadsyt => _items.length;

  /// total download
  int get totalDownload => _audios.length + _videos.length + _photos.length;

  /// progress bar
  List<double> prog = <double>[];

  /// url
  List<String> url = <String>[];

  /// path+name
  List<String> pathName = <String>[];

  /// cart from the outside.
  void add(YoutubeDownloadModel item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// adddwon
  void adddownload(double item) {
    prog.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// this is shit
  void addUrl(String u) {
    url.add(u);
    notifyListeners();
  }

  /// this is shit
  void addtoPathandName(String u, String p) {
    // This call tells the widgets that are listening to this model to rebuild.
    url.add(u);
    pathName.add(p);
    notifyListeners();
  }
}
