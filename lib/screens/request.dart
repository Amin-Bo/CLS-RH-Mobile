import 'package:flutter/material.dart';

class RequsetScreen extends StatefulWidget {
  const RequsetScreen({Key? key}) : super(key: key);

  @override
  State<RequsetScreen> createState() => _RequsetScreenState();
}

class _RequsetScreenState extends State<RequsetScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Request'),
    );
  }
}
