// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:cls_rh/constants.dart';
import 'package:cls_rh/screens/components/request_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './request_list.dart' as reqList;

class RequestDialog extends StatelessWidget {
  var type = "";

  RequestDialog({Key? key, this.type = ""}) : super(key: key);

  void SendRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? _id = sharedPreferences.get('_id').toString();
    var userobj = {_id: _id};
    var user = jsonEncode({"user": userobj});
    String? token = sharedPreferences.get('token').toString();
    Uri url = Uri.parse(cls_URL + "api/employee/addRequest");
    url.replace(queryParameters: {
      "user": user,
    });
    Map<String, String> headers = {"Content-type": "application/json"};
    var body = jsonEncode({
      "type": type,
      "user": user,
    });

    var res = await http.post(
      url,
      headers: <String, String>{
        "Authorization": "jwt " + token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(res.statusCode);
    print(res.body);
    RequestList();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(110, 184, 184, 184),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Asked for $type certification'),
                content: const Text(
                    'Your Request is in queue now you will recieve a notification when it is treated'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      SendRequest();
                      Navigator.pop(context, 'Ok');
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
        child: Row(
          children: const [
            Icon(
              Icons.send_outlined,
              color: Color.fromARGB(255, 105, 184, 102),
            ),
            Text(
              '  Send Request',
              style: TextStyle(color: Color.fromARGB(255, 112, 112, 112)),
            ),
          ],
        ));
  }
}

class RequestStepper extends StatefulWidget {
  const RequestStepper({Key? key}) : super(key: key);

  @override
  State<RequestStepper> createState() => _RequestStepperState();
}

class _RequestStepperState extends State<RequestStepper> {
  var _index = 0;
  var type = "";
  String _salutation =
      "work"; //This is the selection value. It is also present in my array.
  final _salutations = ["internship", "work"];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "Request Type :",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              DropdownButton(
                items: _salutations
                    .map((String item) => DropdownMenuItem<String>(
                        child: Text(item), value: item))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    this._salutation = value!;
                  });
                },
                value: _salutation,
              ),
            ],
          ),
          RequestDialog(type: _salutation),
        ],
      ),
    );
  }
}
