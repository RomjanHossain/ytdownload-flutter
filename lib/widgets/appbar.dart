import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:ytdownload/pages/download/downloadpage.dart';
import 'package:ytdownload/services/getvidyt.dart';
import 'package:ytdownload/utils/const.dart';

/// my app bar
NeumorphicAppBar myAppBar(
  BuildContext context,
  String title,
  isNavBack back,
  isDown down,
  isDispo dispo,
) {
  return NeumorphicAppBar(
    title: Row(
      children: <Widget>[
        SvgPicture.asset(
          'assets/svg/yt.svg',
          alignment: Alignment.centerLeft,
          width: 45,
        ),
        Expanded(
          child: Text(
            title,
            // style: NeumorphicTheme.currentTheme(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
          ),
        ),
      ],
    ),
    /* automaticallyImplyLeading: false, */

    centerTitle: back == isNavBack.yes,
    leading: back == isNavBack.yes
        ? NeumorphicButton(
            style: const NeumorphicStyle(
              /* shadowDarkColor: Colors.black, */
              boxShape: NeumorphicBoxShape.circle(),
              depth: 2,
              intensity: 0.6,
            ),
            onPressed: () {
              if (dispo == isDispo.yes) {
                Provider.of<GetVideosFromYT>(context, listen: false).dispoo();
              }
              Navigator.pop(context);
            },
            child: const Icon(Icons.navigate_before))
        : null,
    actions: <Widget>[
      /// drawer button
      if (down == isDown.yes)
        NeumorphicButton(
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: 2,
            intensity: 0.6,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const DownloadPage(),
              ),
            );
          },
          child: const Icon(
            LineIcons.download,
            // color: Colors.black,
          ),
        )
      else
        const SizedBox.shrink()
    ],
  );
}
