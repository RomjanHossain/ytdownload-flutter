import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownload/utils/audio.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/utils/fullvid.dart';
import 'package:ytdownload/utils/onlyvid.dart';

/// show download listo
void showDownloadListo(
  BuildContext context,
  String title,
  VideoId id,
  String thumbLow,
  String thumbMid,
  String thumbHigh,
  // String thumb4,
) {
  // final AudioOnlyStreamInfo audio = manifest.audioOnly.last;
  // vido = manifest.videoOnly

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext builder) {
      return Neumorphic(
        style: const NeumorphicStyle(
          color: kprimaryColor,
          boxShape: NeumorphicBoxShape.rect(),
          /* intensity: 0.1, */
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Full-Videos',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            fullvidWidgets(id, context, thumbMid, title),
            Padding(
              /* padding: const EdgeInsets.all(8.0), */
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Only Audio',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            audioWidgets(id, context, thumbMid, title),
            Padding(
              /* padding: const EdgeInsets.all(8.0), */
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Only Video',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            videoWidgets(id, context, thumbMid, title),
            Padding(
              /* padding: const EdgeInsets.all(8.0), */
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Thumbnails',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: <Widget>[
                NeumorphicButton(
                  onPressed: () {},
                  margin: const EdgeInsets.only(
                    top: 30,
                    left: 30,
                    right: 30,
                  ),
                  padding: const EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    /* color: kprimaryColor, */
                    color: Colors.cyanAccent.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      Text('High  '),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  /* margin: const EdgeInsets.all(30), */
                  margin: const EdgeInsets.only(
                    top: 30,
                    left: 30,
                    right: 30,
                  ),
                  padding: const EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    /* color: kprimaryColor, */
                    color: Colors.cyanAccent.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      Text('Midium'),
                    ],
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  /* margin: const EdgeInsets.all(30), */
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(10),
                  style: NeumorphicStyle(
                    /* color: kprimaryColor, */
                    color: Colors.cyanAccent.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      Text('Low   '),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
