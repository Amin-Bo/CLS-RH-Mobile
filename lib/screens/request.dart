import 'package:cls_rh/screens/components/request_dialog.dart';
import 'package:cls_rh/screens/components/request_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class RequsetScreen extends StatefulWidget {
  const RequsetScreen({Key? key}) : super(key: key);

  @override
  State<RequsetScreen> createState() => _RequsetScreenState();
}

class _RequsetScreenState extends State<RequsetScreen> {
  var screen = true;
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    var androidInitialize = new AndroidInitializationSettings("app_icon");
    var initialzation = new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Used for removing back buttoon.
        title: const Text("Request"),
      ),
      body: SingleChildScrollView(
        //height: MediaQuery.of(context).size.height * .9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: RequestStepper(),
            ),
            SingleChildScrollView(child: RequestList())
          ],
        ),
      ),
    );
  }
}
