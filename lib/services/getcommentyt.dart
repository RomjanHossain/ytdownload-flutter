// import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// get videos from youtube
class GetCommentsFromYT extends ChangeNotifier {
  /// yt explode
  YoutubeExplode yt = YoutubeExplode();

  /// last commet
  late CommentsList lastComment;

  /// Isdafsd
  List<Comment> myListssss = <Comment>[];

  /// future comment
  Future<List<Comment>> forfuture() async {
    return myListssss;
  }

  /// get comments from videos
  Future<void> getcomments(String id) async {
    final Video video = await yt.videos.get(id);
    final CommentsList? comments =
        await yt.videos.commentsClient.getComments(video);
    comments!.forEach((Comment p0) {
      myListssss.add(p0);
    });
    lastComment = comments;
    notifyListeners();
  }

  /// get next comments
  Future<void> getnextcomments() async {
    lastComment.nextPage().then((CommentsList? value) {
      if (value!.isNotEmpty) {
        value.forEach((Comment p0) {
          myListssss.add(p0);
        });
        lastComment = value;
      }
    });
    notifyListeners();
  }

  /// this is should go in future
  void dispoo() {
    myListssss = <Comment>[];
    notifyListeners();
  }
}
