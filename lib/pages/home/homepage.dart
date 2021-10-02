/* import 'package:flutter/material.dart'; */
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ytdownload/pages/home/body.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';

/// my home page
class MyHomePage extends StatelessWidget {
  /// constractor
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      darkTheme: dktheme,
      theme: ltheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // backgroundColor: Colors.red,
        appBar: myAppBar(
          context,
          'Youtube Downloader',
          isNavBack.no,
          isDown.yes,
          isDispo.no,
        ),
        body: MyBody(),
      ),
    );
  }
}
