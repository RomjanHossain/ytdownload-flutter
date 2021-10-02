/* import 'package:flutter/material.dart'; */
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ytdownload/pages/home/body.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';

/// my home page
class MyHomePage extends StatelessWidget {
  /// constractor
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.currentTheme(context).baseColor,
      appBar: myAppBar(
        context,
        'Youtube Downloader',
        isNavBack.no,
        isDown.yes,
        isDispo.no,
      ),
      body: MyBody(),
      floatingActionButton: NeumorphicFloatingActionButton(
        mini: true,
        child: const Icon(Icons.brightness_7),
        onPressed: () {
          if (NeumorphicTheme.of(context)!.isUsingDark) {
            NeumorphicTheme.of(context)!.themeMode = ThemeMode.light;
          } else {
            NeumorphicTheme.of(context)!.themeMode = ThemeMode.dark;
          }
        },
      ),
    );
  }
}
