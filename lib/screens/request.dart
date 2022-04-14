import 'package:cls_rh/screens/components/request_dialog.dart';
import 'package:cls_rh/screens/components/request_list.dart';
import 'package:flutter/material.dart';

class RequsetScreen extends StatefulWidget {
  const RequsetScreen({Key? key}) : super(key: key);

  @override
  State<RequsetScreen> createState() => _RequsetScreenState();
}

class _RequsetScreenState extends State<RequsetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Used for removing back buttoon.
        title: const Text("Request"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
