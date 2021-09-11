import 'package:flutter/material.dart';
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
      themeMode: ThemeMode.light,
      darkTheme: const NeumorphicThemeData(
        baseColor: NeumorphicColors.darkBackground,
        accentColor: NeumorphicColors.darkAccent,
        depth: 6,
        intensity: 0.3,
      ),
      theme: const NeumorphicThemeData(
        baseColor: kprimaryColor,
        depth: 10,
        intensity: 0.5,
      ),
      child: Scaffold(
        backgroundColor: kprimaryColor,
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
