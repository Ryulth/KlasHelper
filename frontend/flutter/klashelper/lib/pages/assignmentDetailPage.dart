import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';

class AssignmentDetailPage extends StatefulWidget {
  final Assignment assignment;
  final TargetPlatform platform;
  AssignmentDetailPage({
    Key key,
    @required this.assignment,
    @required this.platform
  }): super(key: key);

  @override
  AssignmentDetailPageState createState() => new AssignmentDetailPageState();
}

class AssignmentDetailPageState extends State < AssignmentDetailPage > {
  String _localPath;

  void downloadFile(_fileName, _link) async {
    if (_link == "no_files" || _fileName == "파일 없음") {
      return;
    }
    //PlatformException
    var _downloadPath = await getDownloadFilePath(_fileName, _link);
    Timer.periodic(new Duration(seconds: 1), (timer) {
      try{
      OpenFile.open(_downloadPath).then((res) {
        if (res == "done") {
          timer.cancel();
        
        }
      });
      }catch(e) {
        print("열 수 없는 파일 형식입니다.");
        timer.cancel();
      }
    });
  }

  Future < String > getDownloadFilePath(_fileName, _link) async {
    await FlutterDownloader.enqueue(
      url: _link,
      savedDir: _localPath,
      fileName: _fileName,
      showNotification: false, // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
    return _localPath + "/" + _fileName;
  }

  Future < String > _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android ?
      await getExternalStorageDirectory() :
      await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future < Null > _prepare() async {
    await _checkPermission();
    _localPath = (await _findLocalPath()) + '/Download/KlasHelper';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
  Future < bool > _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map < PermissionGroup, PermissionStatus > permissions =
          await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("과제 정보"),
        actions: < Widget > [
          IconButton(
            icon: Icon(FontAwesomeIcons.trash),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: < Widget > [
          Container(
            height: 10.0,
          ),
          Container(
            height: 70.0,
            child: ListTile(
              title: Text(
                widget.assignment.workTitle,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                widget.assignment.workCourse + "\n" +
                widget.assignment.workCreateTime + " ~ " +
                widget.assignment.workFinishTime,
                style: TextStyle(fontSize: 15),
              ),
              isThreeLine: true,
            ),
          ),
          Container(
            child: ListTile(
              onTap: () {
                downloadFile(widget.assignment.getFileName(), widget.assignment.getFileUrl());
              },
              leading: Icon(FontAwesomeIcons.download),
              title: Text('첨부 파일'),
              subtitle: Text(widget.assignment.getFileName()),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.assignment.toJson().toString(),
                  style: TextStyle(fontSize: 20),
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
          ),
        ],
      )
    );
  }
}