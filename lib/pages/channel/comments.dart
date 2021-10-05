import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownload/services/getcommentyt.dart';
import '../../utils/const.dart';

/// show download listo
void showCommmentos(
  BuildContext context,
  String videoID,
) {
  showModalBottomSheet<void>(
      backgroundColor: NeumorphicTheme.currentTheme(context).baseColor,
      context: context,
      builder: (BuildContext builder) {
        return AllComments(
          myID: videoID,
        );
      });
}

///
class AllComments extends StatefulWidget {
  ///
  const AllComments({
    Key? key,
    required this.myID,
    /* required this.contx, */
  }) : super(key: key);

  /// video ID
  final String myID;

  /// futre comk
  /* final Future contx; */

  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  ScrollController controller = ScrollController();
  late Future<List<Comment>> _commentFuture;
  @override
  void initState() {
    /* print('init state'); */
    super.initState();
    commentfuture();
    Provider.of<GetCommentsFromYT>(context, listen: false)
        .getcomments(widget.myID)
        .then((value) {
      setState(() {});
    });
    controller.addListener(controllerListener);
  }

  void commentfuture() {
    setState(() {
      _commentFuture =
          Provider.of<GetCommentsFromYT>(context, listen: false).forfuture();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    /* Provider.of<GetCommentsFromYT>(context, listen: false).dispoo(); */
  }

  void controllerListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      Provider.of<GetCommentsFromYT>(context, listen: false).getnextcomments();

      /* setState(() {}); */
      print('this is out of ranger shitshis hiksdkfj');
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: _commentFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              /* print(snapshot.data[index].text); */
              return Neumorphic(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          snapshot.data![index].author,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: kytcol),
                        ),
                        Text(snapshot.data![index].publishedTime),
                      ],
                    ),
                    Text(
                      snapshot.data![index].text,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ],
          );
        }
        /* return Text('shit'); */
      },
    );
  }
}
