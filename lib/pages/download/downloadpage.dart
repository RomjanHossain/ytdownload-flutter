import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';

/// download page
class DownloadPage extends StatelessWidget {
  /// constratro
  const DownloadPage({Key? key}) : super(key: key);

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
              'Downloads',
              isNavBack.yes,
              isDown.no,
            )));
  }
}
