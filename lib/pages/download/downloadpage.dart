import 'dart:ui';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ytdownload/pages/download/downloadpageitem.dart';
import 'package:ytdownload/services/provider/ytprovider.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';

/// shiting page
class DownloadPage extends StatelessWidget {
  /// shiting page
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: myAppBar(
        context,
        'Downloads',
        isNavBack.yes,
        isDown.no,
        isDispo.no,
      ),
      body: Provider.of<YoutubeDownloadProvider>(context, listen: false)
                  .totalDownload >
              0
          ? DownloadPageItem(
              context: context,
            )
          : Center(
              child: Text(
                'No Downloads Yet',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      /* fontStyle: FontStyle.italic, */
                      fontWeight: FontWeight.w100,
                    ),
                /* textAlign: TextAlign.center, */
              ),
            ),
    );
  }
}
