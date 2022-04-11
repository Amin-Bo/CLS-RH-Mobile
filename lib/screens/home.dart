import 'package:cls_rh/screens/components/bottom_bar.dart';
import 'package:cls_rh/screens/leaves.dart';
import 'package:cls_rh/screens/login.dart';
import 'package:cls_rh/screens/profile.dart';
import 'package:cls_rh/screens/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlutterLocalNotificationsPlugin localNotification;
  @override
  void initState() {
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var IOSInitialize = new IOSInitializationSettings();
    var initialzation = new InitializationSettings(
        android: androidInitialize, iOS: IOSInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzation);

    super.initState();
  }

  Future _showNotif() async {
    var AndroidDetails = new AndroidNotificationDetails(
        "channel Id", "Local Notification",
        channelDescription: "Notification Channel",
        importance: Importance.high);
  }

  final _inactiveColor = Colors.grey;
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: getBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.white,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.account_circle_outlined),
          title: Text(
            'Profile ',
          ),
          activeColor: Color.fromARGB(255, 114, 164, 255),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.contact_mail_outlined,
          ),
          title: Text('Requests '),
          activeColor: Color.fromARGB(255, 114, 164, 255),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.night_shelter_outlined,
          ),
          title: Text('Leaves'),
          activeColor: Color.fromARGB(255, 114, 164, 255),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [ProfileScreen(), RequsetScreen(), LeavesScreen()];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
