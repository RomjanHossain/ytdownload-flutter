import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ytdownload/pages/home/homepage.dart';
import 'package:ytdownload/services/getvidyt.dart';
import 'package:ytdownload/services/provider/ytprovider.dart';
import 'package:ytdownload/utils/const.dart';

void main() {
  _initDownloader();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GetVideosFromYT>(
          create: (BuildContext context) => GetVideosFromYT(),
        ),
        ChangeNotifierProvider<YoutubeDownloadProvider>(
          create: (BuildContext context) => YoutubeDownloadProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

/// my init app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awesome Youtube Downloader',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
            /* bodyColor: Colors.white, */
            ),
      ),
      home:  NeumorphicTheme(
        darkTheme: dktheme,
      theme: ltheme,
        child:const MyHomePage(),
        ),
    );
  }
}

/// slkdjfls
Future<void> _initDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      /* debug: true // optional: set false to disable printing logs to console */
      );
}
