import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class DownloadingDialog extends StatefulWidget {
  var url;

  var fileName;

  DownloadingDialog({Key? key, this.url = "", this.fileName = ""})
      : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {
    String url = widget.url;
    String fileName = widget.fileName + ".pdf";

    String path = await _getFilePath(fileName);

    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      print("Downloaded");
      Navigator.pop(context);
    });
  }

  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  Future _showNotif() async {
    var AndroidDetails = new AndroidNotificationDetails(
      "channel Id",
      "Local Notification",
      channelDescription: "Notification Channel",
      icon: "@mipmap/ic_launcher",
      importance: Importance.high,
      visibility: NotificationVisibility.public,
      groupAlertBehavior: GroupAlertBehavior.all,
      showProgress: true,
    );
    var generalNotification = new NotificationDetails(android: AndroidDetails);
    await localNotification.show(
      0,
      " Pdf downloaded successfully",
      "Check your download folder Pdf name : ${widget.fileName}",
      generalNotification,
    );
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory? extDir = await getExternalStorageDirectory();
    final String dirPath = extDir!.path.toString();
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/';
    final output = await getExternalStorageDirectory();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    RegExp pathToDownloads = new RegExp(r'.+0\/');

    final downloadPath =
        '${pathToDownloads.stringMatch(output!.path).toString()}Download';
    final file = File('$downloadPath/$filename');
    print(downloadPath);
    return "$downloadPath/$filename";
  }

  @override
  void initState() {
    super.initState();
    var androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialzation = new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzation);
    startDownloading();
    _showNotif();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Color.fromARGB(61, 0, 0, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
