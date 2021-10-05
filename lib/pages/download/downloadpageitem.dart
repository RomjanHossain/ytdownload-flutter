import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ytdownload/models/ytmodel.dart';
import 'package:ytdownload/services/provider/ytprovider.dart';
import 'package:ytdownload/utils/const.dart';

/// download page
class DownloadPageItem extends StatefulWidget {
  /// constratro

  const DownloadPageItem({
    Key? key,
    required this.context,
  }) : super(key: key);

  /// connnn
  final BuildContext context;

  @override
  _DownloadPageItemState createState() => _DownloadPageItemState();
}

class _DownloadPageItemState extends State<DownloadPageItem> {
  /// tasks
  List<YoutubeDownloadModel>? _tasks;
  Directory? directory;
  late List<_ItemHolder> _items;
  late bool _isLoading;
  late bool _permissionReady;
  late String _localPath;
  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare(widget.context);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final bool isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (true) {
        /* print('UI Isolate Callback: $data'); */
      }
      final String id = data[0].toString();
      final DownloadTaskStatus status = data[1] as DownloadTaskStatus;
      final int progress = data[2] as int;

      if (_tasks != null && _tasks!.isNotEmpty) {
        final YoutubeDownloadModel task = _tasks!
            .firstWhere((YoutubeDownloadModel task) => task.taskid == id);
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    if (true) {
      /* print( */
      /* 'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)'); */
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _permissionReady
              ? _buildDownloadList()
              : _buildNoPermissionWarning(),
    );
  }

  Widget _buildDownloadList() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        children: _items
            .map(
              (_ItemHolder item) => item.task == null
                  ? _buildListSection(item.name!)
                  : DownloadItem(
                      data: item,
                      onItemClick: (YoutubeDownloadModel? task) {
                        _openDownloadedFile(task).then((bool success) {
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('cannot open this file'),
                              ),
                            );
                          }
                        });
                      },
                      onActionClick: (YoutubeDownloadModel task) {
                        if (task.status == DownloadTaskStatus.undefined) {
                          _requestDownload(task);
                        } else if (task.status == DownloadTaskStatus.running) {
                          _pauseDownload(task);
                        } else if (task.status == DownloadTaskStatus.paused) {
                          _resumeDownload(task);
                        } else if (task.status == DownloadTaskStatus.complete) {
                          _delete(task);
                        } else if (task.status == DownloadTaskStatus.failed) {
                          _retryDownload(task);
                        }
                      },
                    ),
            )
            .toList(),
      );

  Widget _buildListSection(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildNoPermissionWarning() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Please grant accessing storage permission to continue -_-',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextButton(
              onPressed: () {
                _retryRequestPermission();
              },
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            )
          ],
        ),
      );

  Future<void> _retryRequestPermission() async {
    final bool hasGranted = await _checkPermission(Permission.storage);

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(YoutubeDownloadModel task) async {
    String _ext;
    if (task.type == TypeDownload.audio) {
      _ext = 'mp3';
    } else if (task.type == TypeDownload.video ||
        task.type == TypeDownload.fullvideo) {
      _ext = 'mp4';
    } else {
      _ext = 'jpg';
    }
    task.taskid = await FlutterDownloader.enqueue(
      url: task.url,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      /* fileName:  */
      fileName: '${task.title}.$_ext',
    );
  }

  Future<void> _cancelDownload(YoutubeDownloadModel task) async {
    await FlutterDownloader.cancel(taskId: task.taskid!);
  }

  Future<void> _pauseDownload(YoutubeDownloadModel task) async {
    await FlutterDownloader.pause(taskId: task.taskid!);
  }

  Future<void> _resumeDownload(YoutubeDownloadModel task) async {
    final String? newTaskId =
        await FlutterDownloader.resume(taskId: task.taskid!);
    task.taskid = newTaskId;
  }

  Future<void> _retryDownload(YoutubeDownloadModel task) async {
    final String? newTaskId =
        await FlutterDownloader.retry(taskId: task.taskid!);
    task.taskid = newTaskId;
  }

  Future<bool> _openDownloadedFile(YoutubeDownloadModel? task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskid!);
    } else {
      return Future.value(false);
    }
  }

  /// ksjlfskd
  Future<void> _delete(YoutubeDownloadModel task) async {
    await FlutterDownloader.remove(
      taskId: task.taskid!,
      shouldDeleteContent: true,
    );
    await _prepare(widget.context);
    setState(() {});
  }

  Future<bool> _checkPermission(Permission permission) async {
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

  /// thumbnail shit

  Future<void> _prepare(BuildContext context) async {
    final List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = <YoutubeDownloadModel>[];
    _items = <_ItemHolder>[];

    _tasks!.addAll(
      Provider.of<YoutubeDownloadProvider>(widget.context, listen: false)
          .audios,
    );

    _items.add(_ItemHolder(name: 'Audios'));
    for (int i = count; i < _tasks!.length; i++) {
      _items.add(
        _ItemHolder(
          name: _tasks![i].title,
          task: _tasks![i],
          thumb: _tasks![i].thumb,
          quality: _tasks![i].quality,
        ),
      );
      count++;
    }

    _tasks!.addAll(
      Provider.of<YoutubeDownloadProvider>(widget.context, listen: false)
          .photos,
    );

    _items.add(_ItemHolder(name: 'Thumbnails'));
    for (int i = count; i < _tasks!.length; i++) {
      _items.add(
        _ItemHolder(
          name: _tasks![i].title,
          task: _tasks![i],
          thumb: _tasks![i].thumb,
          quality: _tasks![i].quality,
        ),
      );
      count++;
    }

    _tasks!.addAll(
      Provider.of<YoutubeDownloadProvider>(widget.context, listen: false)
          .videos,
    );

    _items.add(_ItemHolder(name: 'Only Videos'));
    for (int i = count; i < _tasks!.length; i++) {
      _items.add(
        _ItemHolder(
          name: _tasks![i].title,
          task: _tasks![i],
          thumb: _tasks![i].thumb,
          quality: _tasks![i].quality,
        ),
      );
      count++;
    }

    _tasks!.addAll(
      Provider.of<YoutubeDownloadProvider>(widget.context, listen: false)
          .fullvideos,
    );
    /* _tasks!.addAll(_videos.map((video) => */
    /*     YoutubeDownloadModel(name: video['name'], link: video['link']))); */

    _items.add(_ItemHolder(name: 'Full-Videos'));
    for (int i = count; i < _tasks!.length; i++) {
      _items.add(
        _ItemHolder(
          name: _tasks![i].title,
          task: _tasks![i],
          thumb: _tasks![i].thumb,
          quality: _tasks![i].quality,
        ),
      );
      count++;
    }

    for (final task in tasks!) {
      for (final YoutubeDownloadModel info in _tasks!) {
        if (info.url == task.url) {
          info.taskid = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission(Permission.storage);

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final Directory savedDir = Directory(_localPath);
    final bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    /* var externalStorageDirPath; */
    if (Platform.isAndroid) {
      try {
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
        return '$newPath/Download';
      } catch (e) {
        directory = await getExternalStorageDirectory();

        return directory!.path;
      }
    }
  }
}

/// download item
class DownloadItem extends StatelessWidget {
  /// skjlsk
  const DownloadItem({this.data, this.onItemClick, this.onActionClick});

  /// data
  final _ItemHolder? data;

  /// onclick
  final Function(YoutubeDownloadModel?)? onItemClick;

  /// on acktion
  final Function(YoutubeDownloadModel)? onActionClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: data!.task!.status == DownloadTaskStatus.complete
            ? () {
                onItemClick!(data!.task);
              }
            : null,
        child: Neumorphic(
          margin: const EdgeInsets.all(10),
          style: const NeumorphicStyle(
            intensity: 0.35,
          ),
          child: Stack(
            children: <Widget>[
              /* SizedBox(height: 64, child: Image.network(data!.thumb!)), */
              SizedBox(
                width: double.infinity,
                height: 64.0,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Image.network(data!.thumb!),
                    ),
                    Expanded(
                      child: Text(
                        data!.name!,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildActionForTask(data!.task!),
                    ),
                  ],
                ),
              ),
              if (data!.task!.status == DownloadTaskStatus.running ||
                  data!.task!.status == DownloadTaskStatus.paused)
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: NeumorphicProgress(
                    percent: data!.task!.progress! / 100,
                  ),
                )
              else
                Container()
            ].toList(),
          ),
        ),
      ),
    );
  }

  Widget? _buildActionForTask(YoutubeDownloadModel task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return NeumorphicButton(
        onPressed: () {
          onActionClick!(task);
        },
        /* shape: const CircleBorder(), */
        child: const Icon(
          LineIcons.download,
        ),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return NeumorphicButton(
        onPressed: () {
          onActionClick!(task);
        },
        /* shape: const CircleBorder(), */
        child: const Icon(
          Icons.pause,
          color: Colors.red,
        ),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return NeumorphicButton(
        onPressed: () {
          onActionClick!(task);
        },
        /* shape: const CircleBorder(), */
        child: const Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text(
            'Ready',
            style: TextStyle(color: Colors.green),
          ),
          NeumorphicButton(
            onPressed: () {
              onActionClick!(task);
            },
            /* shape: const CircleBorder(), */
            child: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return const Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text('Failed', style: TextStyle(color: Colors.red)),
          NeumorphicButton(
            onPressed: () {
              onActionClick!(task);
            },
            /* shape: const CircleBorder(), */
            child: const Icon(
              Icons.refresh,
              color: Colors.green,
            ),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return const Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }
}

class _ItemHolder {
  _ItemHolder({this.name, this.task, this.quality, this.thumb});
  final String? name;
  final String? quality;
  final String? thumb;
  final YoutubeDownloadModel? task;
}
