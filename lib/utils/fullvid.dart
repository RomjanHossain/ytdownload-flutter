import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownload/models/ytmodel.dart';
import 'package:ytdownload/services/provider/ytprovider.dart';
import 'package:ytdownload/utils/const.dart';

/// get audiowidgets
FutureBuilder<List<Widget>> fullvidWidgets(
    VideoId id, BuildContext context, String thumbMid, String title) {
  return FutureBuilder<List<Widget>>(
    future: getfullvideo(id, context, thumbMid, title),
    // initialData: InitialData,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        /* print('this is snap ${snapshot.data[0]}'); */
        // return snapshot.data[0] as Widget;
        return Column(
          children: snapshot.data as List<Widget>,
        );
      } else if (snapshot.hasError) {
        return Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ],
        );
      } else {
        return const Padding(
            padding: EdgeInsets.all(50),
            child: Center(child: CircularProgressIndicator()));
      }
    },
  );
}

/// get fulvidios
Future<List<Widget>> getfullvideo(
    VideoId id, BuildContext context, String thumbMid, String title) async {
  final YoutubeExplode yt = YoutubeExplode();
  final List<Widget> fullwid = <Widget>[];
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);

  for (final VideoStreamInfo i in manifest.muxed) {
    final List<String> _sp = i.size.toString().split('.');
    final String _f = _sp[0];
    final String _l = _sp[1].substring(0, 2);
    final String _ext = _sp[1].substring(_sp[1].length - 2);
    fullwid.add(NeumorphicButton(
      onPressed: () {
        /* print('pressed only vid shit'); */
        Provider.of<YoutubeDownloadProvider>(context, listen: false)
            .addFullvideoaudio(YoutubeDownloadModel(
                thumbMid,
                title,
                i.videoQuality.toString(),
                'loc',
                i.url.toString(),
                id,
                TypeDownload.fullvideo));
        Navigator.pop(context);
      },
      margin: const EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      padding: const EdgeInsets.all(10),
      style: NeumorphicStyle(
        color: Colors.blueAccent.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(i.videoQualityLabel),
          const Text('|'),
          Text('$_f.$_l $_ext'),
        ],
      ),
    ));
  }
  return fullwid;
}
