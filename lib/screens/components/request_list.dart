// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cls_rh/constants.dart';
import 'package:cls_rh/screens/components/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

var refreshKeyy = GlobalKey<RefreshIndicatorState>();
Color? in_progress = Colors.orange;
Color? done = Colors.green;
Color? declined = Colors.red;
var requests = [];

class _RequestListState extends State<RequestList> {
  void getRequests() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? from = sharedPreferences.get('_id').toString();
    String? token = sharedPreferences.get('token').toString();
    Uri url = Uri.parse(cls_URL + "api/employee/getRequest/work");
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "jwt " + token
    };
    var res = await http.get(
      url,
      headers: headers,
    );
    print(res.statusCode);
    var jsonData = await json.decode(res.body);
    requests = jsonData['request'];
    requests.sort((a, b) => DateTime.parse(a['sent_date'])
        .compareTo(DateTime.parse(b['sent_date']))
        .toInt());
    print(requests);
    //requests = await jsonData.request;
  }

  colorback(status) {
    if (status == "in progress") {
      return in_progress;
    } else if (status == "done") {
      return done;
    } else if (status == "declined") {
      return declined;
    } else {
      return Color.fromARGB(255, 0, 0, 0);
    }
  }

  checkStatus(String status) {
    if (status == "in progress") {
      return "in progress";
    } else if (status == "done") {
      return "done";
    } else if (status == "declined") {
      return "declined";
    } else {
      return 'in progress';
    }
  }

  Future<void> _refresh() async {
    refreshKeyy.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getRequests();
    });
  }

  @override
  void initState() {
    getRequests();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.builder(
          itemCount: requests.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            if (requests.length > 0) {
              return ListTile(
                leading: Icon(Icons.file_copy),
                title: Text(requests[index]['type']),
                subtitle: Text("Envoyé le " +
                    DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(requests[index]['sent_date']))),
                trailing: IconButton(
                  onPressed: () {
                    switch (checkStatus(requests[index]['status'])) {
                      case "in progress":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.up,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.orange,
                          content: Text("this request is in progress "),
                        ));
                        break;
                      case "done":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewer(
                              pdf: cls_URL +
                                  'assets/certifications/' +
                                  requests[index]["file"],
                              fileName: requests[index]["_id"],
                            ),
                          ),
                        );
                        break;
                      case "declined":
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.up,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.red,
                          content: Text("this request has been declined"),
                        ));
                        break;

                      default:
                        break;
                    }
                  },
                  icon: Icon(Icons.file_download),
                  color: colorback(requests[index]['status']),
                ),
              );
            } else {
              return ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('No file found'),
                subtitle: Text(' no file found'),
                trailing: Text('x'),
              );
            }
          },
        ),
      ),
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      displacement: 50,
      onRefresh: _refresh,
      //key: refreshKeyy,
      color: Color.fromARGB(255, 98, 167, 245),
    );
  }
}

mixin SnackBarAnimation {}
