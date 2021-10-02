import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ytdownload/pages/results/showallresults.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';

/// view search result

class ShowingResult extends StatelessWidget {
  /// constractor
  const ShowingResult({Key? key, required this.query, required this.st})
      : super(key: key);

  /// search query
  final String query;

  /// search to where
  final SearchTo st;

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(

      darkTheme: const NeumorphicThemeData(
        baseColor: kprimaryColorD,
        appBarTheme: NeumorphicAppBarThemeData(
          color: kprimaryColorD,
          textStyle: TextStyle(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        depth: 6,
        intensity: 0.3,
      ),
      theme: const NeumorphicThemeData(
        baseColor: kprimaryColor,
        appBarTheme: NeumorphicAppBarThemeData(
          color: kprimaryColor,
        ),
        depth: 10,
        intensity: 0.5,
      ),
      child: Scaffold(
        backgroundColor: NeumorphicTheme.currentTheme(context).baseColor,
        // backgroundColor: Colors.red,
        appBar:
            myAppBar(context, query, isNavBack.yes, isDown.yes, isDispo.yes),
        body: ShowingListOfVideos(
          query: query,
          where: st,
        ),
      ),
    );
  }
}
