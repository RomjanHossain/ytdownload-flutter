/* import 'dart:convert'; */
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart'
    show
        Animatable,
        Animation,
        BuildContext,
        Color,
        Cubic,
        CurveTween,
        Curves,
        Offset,
        PageRouteBuilder,
        SlideTransition,
        Tween,
        Widget;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
/* import 'package:flutter_local_notifications/flutter_local_notifications.dart'; */
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// neumorphic dark theme
const NeumorphicThemeData dktheme = NeumorphicThemeData(
  baseColor: kprimaryColorD,
  // accentColor: NeumorphicColors.darkAccent,
  defaultTextColor: Colors.white,
  buttonStyle: NeumorphicStyle(
      /* intensity: 0.2, */
      ),
  appBarTheme: NeumorphicAppBarThemeData(
    color: kprimaryColorD,
    textStyle: TextStyle(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
    caption: TextStyle(color: Colors.white),
    headline1: TextStyle(color: Colors.white),
    headline3: TextStyle(color: Colors.white),
    headline2: TextStyle(color: Colors.white),
    headline4: TextStyle(color: Colors.white),
    headline5: TextStyle(color: Colors.white),
    headline6: TextStyle(color: Colors.white),
    overline: TextStyle(color: Colors.white),
    subtitle1: TextStyle(color: Colors.white),
    subtitle2: TextStyle(color: Colors.white),
  ),
  depth: 6,
  intensity: 0.3,
);

/// neumophic light theme
const NeumorphicThemeData ltheme = NeumorphicThemeData(
  baseColor: kprimaryColor,
  // defaultTextColor: Colors.black,
  textTheme: TextTheme(button: TextStyle(color: Colors.black,)),
  appBarTheme: NeumorphicAppBarThemeData(
    color: kprimaryColor,
    textStyle: TextStyle(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  depth: 10,
  intensity: 0.5,
);

/// my primary light theme color
const Color kprimaryColor = Color(0xffEFE9EB);

/// my primary light theme color
const Color kprimaryColorD = Color(0xff243441);

/// yt red color
const Color kytcol = Color(0xffFF0000);

/// xD
enum isNavBack {
  ///
  yes,

  ///
  no,
}

///sdf
enum isDispo {
  ///
  yes,

  ///
  no,
}

///sdf
enum isDown {
  ///
  yes,

  ///
  no,
}

/// enum of downloads types
enum TypeDownload {
  /// audio
  audio,

  /// video,
  video,

  /// full video
  fullvideo,

  /// thumb
  thumbnail,
}

/// enum of search
enum SearchTo {
  /// vid
  video,

  /// playlist
  playlist,

  /// channel
  channel,
}

/// animate page

PageRouteBuilder<dynamic> animateTopage(Widget page2, Offset offset) {
  return PageRouteBuilder<dynamic>(
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        page2,
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      final Offset begin = offset;
      const Offset end = Offset.zero;
      const Cubic curve = Curves.ease;

      final Animatable<Offset> tween =
          Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// generate random number

double krandomGen() {
  final double x = Random().nextDouble() * (2 - (-1)) + (-1);

  // If you don't want to return an integer, just remove the floor() method
  return x.floorToDouble();
}

/// count the duration

String formatDuration(Duration d) {
  final int totalSecs = d.inSeconds;
  final int hours = totalSecs ~/ 3600;
  final int minutes = (totalSecs % 3600) ~/ 60;
  final int seconds = totalSecs % 60;
  final StringBuffer buffer = StringBuffer();

  if (hours > 0) {
    buffer.write('$hours:');
  }
  buffer.write('${minutes.toString().padLeft(2, '0')}:');
  buffer.write(seconds.toString().padLeft(2, '0'));
  return buffer.toString();
}

/// get directory
Future<Directory?> getDownloadDirectory() async {
  Directory? directory;
  if (Platform.isAndroid) {
    if (await requestPermission(Permission.storage)) {
      /* print('permission granted'); */
      directory = await getExternalStorageDirectory();
      // Directory? tempDir = await getExternalStorageDirectory();

      String newPath = '';
      // debugPrint('this is direc$directory');
      final List<String> paths = directory!.path.split('/');
      for (int x = 1; x < paths.length; x++) {
        final String folder = paths[x];
        if (folder != 'Android') {
          newPath += '/$folder';
        } else {
          break;
        }
      }
      newPath = '$newPath/Download';
      /* print(newPath); */
      directory = Directory(newPath);
    }
    return directory;
  }
}

/// get permission
Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final PermissionStatus result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
