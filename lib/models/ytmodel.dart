import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownload/utils/const.dart';

/// Youtube download model
class YoutubeDownloadModel {
  /// Youtube download model  constractor
  YoutubeDownloadModel(
    this.thumb,
    this.title,
    this.quality,
    this.loc,
    this.url,
    this.id,
    this.type,
    /* this.progress, */
  );

  /// thumb
  final String thumb;

  /// title
  final String title;

  /// quality
  final String quality;

  /// location
  final String loc;

  /// url
  final String url;

  /// id
  final VideoId id;

  /// type
  final TypeDownload type;

  /// int process
  int? progress = 0;

  /// task id
  String? taskid;

  /// downloading status
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
