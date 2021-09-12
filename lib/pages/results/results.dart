import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:line_icons/line_icons.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownload/services/getvidyt.dart';
import 'package:ytdownload/services/showdownloadlist.dart';
import 'package:ytdownload/utils/const.dart';
import 'package:ytdownload/widgets/appbar.dart';
import 'package:provider/provider.dart';

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

/// show list of videos

/// sow list
/// showing list of videos
class ShowingListOfVideos extends StatefulWidget {
  /// constractor
  const ShowingListOfVideos(
      {Key? key, required this.query, required this.where})
      : super(key: key);

  /// shitksldkf
  final String query;

  /// ksdjflsk
  final SearchTo where;

  @override
  _ShowingListOfVideosState createState() => _ShowingListOfVideosState();
}

class _ShowingListOfVideosState extends State<ShowingListOfVideos> {
  ScrollController controller = ScrollController();
  late Future _myfuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mybeautifulfuture();
    if (widget.where == SearchTo.video) {
      Provider.of<GetVideosFromYT>(context, listen: false)
          .listoVideos(widget.query)
          .then((value) {
        setState(() {});
      });
    } else if (widget.where == SearchTo.channel) {
      Provider.of<GetVideosFromYT>(context, listen: false)
          .forfutureChannelVideos(widget.query)
          .then((value) {
        Future.delayed(const Duration(seconds: 3)).then((value) {
          setState(() {});
        });
      });
    }
    // setState(() {});
    controller.addListener(controllerListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void controllerListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (widget.where == SearchTo.video) {
        Provider.of<GetVideosFromYT>(context, listen: false).nextVideos();
      } else if (widget.where == SearchTo.channel) {
        Provider.of<GetVideosFromYT>(context, listen: false)
            .nextVideosFromChannel();
      }
      setState(() {});
      /* print('the end2'); */
    }
  }

  void _mybeautifulfuture() {
    if (widget.where == SearchTo.video) {
      setState(() {
        _myfuture =
            Provider.of<GetVideosFromYT>(context, listen: false).forfuture();
      });
    } else if (widget.where == SearchTo.playlist) {
      setState(() {
        _myfuture = Provider.of<GetVideosFromYT>(context, listen: false)
            .forfutureListoVideos(widget.query);
      });
    } else {
      setState(() {
        _myfuture = Provider.of<GetVideosFromYT>(context, listen: false)
            .futurechannelvideos();
      });
      /* setState(() {}); */
    }
  }

  @override
  Widget build(BuildContext context) {
    // hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

    return FutureBuilder(
      future: _myfuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget wid;
        if (snapshot.hasData) {
          wid = ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: controller,
            itemCount: snapshot.data.length as int,
            itemBuilder: (BuildContext context, int index) {
              // print('has dagta-> ${snapshot.data[index].title}');
              return Neumorphic(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                style: NeumorphicStyle(
                  // lightSource: LightSource.bottom,
                  depth: 10,
                  intensity: 0.30,
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Neumorphic(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          style: NeumorphicStyle(
                            depth: 10,
                            intensity: 0.30,
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                          ),
                          child: Image.network(
                            widget.where == SearchTo.video
                                ? Provider.of<GetVideosFromYT>(context,
                                        listen: false)
                                    .myListssss[index]
                                    .thumbnails
                                    .mediumResUrl
                                : snapshot.data[index].thumbnails.mediumResUrl
                                    as String,
                            fit: BoxFit.fitHeight,
                            width: MediaQuery.of(context).size.width / 1,
                            /* height: 200, */
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 10,
                          child: (widget.where == SearchTo.video)
                              ? Text(
                                  Provider.of<GetVideosFromYT>(context,
                                                  listen: false)
                                              .myListssss[index]
                                              .duration !=
                                          null
                                      ? formatDuration(
                                          Provider.of<GetVideosFromYT>(context,
                                                  listen: false)
                                              .myListssss[index]
                                              .duration as Duration,
                                        )
                                      : '00:00',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ))
                              : Text(
                                  snapshot.data[index].duration != null
                                      ? formatDuration(
                                          snapshot.data[index].duration
                                              as Duration,
                                        )
                                      : '00:00',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                        ),
                        Positioned(
                          top: 25,
                          right: 10,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              color: Colors.transparent,
                              boxShape: const NeumorphicBoxShape.stadium(),
                              depth: NeumorphicTheme.embossDepth(context),
                              shape: NeumorphicShape.concave,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                LineIcons.download,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDownloadListo(
                                    context,
                                    snapshot.data[index].title as String,
                                    snapshot.data[index].id as VideoId,
                                    snapshot.data[index].thumbnails.lowResUrl
                                        as String,
                                    snapshot.data[index].thumbnails.mediumResUrl
                                        as String,
                                    snapshot.data[index].thumbnails.highResUrl
                                        as String);
                                /* print('ooooooo'); */
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.where == SearchTo.video
                          ? Provider.of<GetVideosFromYT>(context, listen: false)
                              .myListssss[index]
                              .title
                          : snapshot.data[index].title as String,
                      // overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Author: '),
                        Flexible(
                            child: Text(
                          (widget.where == SearchTo.video)
                              ? Provider.of<GetVideosFromYT>(context,
                                      listen: false)
                                  .myListssss[index]
                                  .author
                              : snapshot.data[index].author as String,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: kytcol,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ))
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          wid = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        } else {
          wid = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              )
            ],
          );
        }
        return wid;
      },
    );
  }
}
