// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cls_rh/screens/components/cardLeave.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../constants.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? file;
  File? fileToUpload;
  DateTime? leave_start_date;
  DateTime? leave_end_date;
  var provider = [];
  String type = "casual";

  void pickFile() async {
    try {
      result = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: false);
      if (result != null) {
        fileName = result!.files.first.name;
        file = result!.files.first;
        fileToUpload = (File(file!.path.toString()));
      }
      // print("file is : ${fileToUpload}");
    } catch (e) {}
  }

  void AddLeave() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? from = sharedPreferences.get('_id').toString();
    Uri url = Uri.parse(cls_URL + "api/leave/addLeave");
    var body = <String, String>{};
    body['from'] = from;
    body['type'] = type;
    body['leave_start_date'] = leave_start_date.toString();
    body['leave_end_date'] = leave_end_date.toString();
    body['leave_type'] = 'Sick';

    http.MultipartRequest request = new http.MultipartRequest("POST", url);
    if (fileToUpload != null) {
      http.MultipartFile? multipartFile =
          await http.MultipartFile.fromPath('file', fileToUpload!.path);
      request.files.add(multipartFile);
    }

    request.fields.addAll(body);
    http.StreamedResponse res = await request.send();

    if (res.statusCode == 200) {
      // snack bar notification
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 83, 209, 87),
        elevation: 10,
        dismissDirection: DismissDirection.down,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text(
          "Leave added successfully",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 255, 70, 70),
        elevation: 10,
        dismissDirection: DismissDirection.down,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ));
    }
  }

  void GetLeaves() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? from = sharedPreferences.get('_id').toString();
    Uri url = Uri.parse(cls_URL + "api/leave/getLeavesByUserId/$from");
    var res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    provider = await json.decode(res.body);
    print(provider);
  }

  Future<void> _refresh() {
    GetLeaves();
    return Future.delayed(Duration(seconds: 0));
  }

  @override
  void initState() {
    GetLeaves();
    print("hello there");
    super.initState();
  }

// fix errors
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _date = 'Tap to select a date';
  @override
  Widget build(BuildContext context) {
    String dropdownValue = "Casual";
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaves'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //refresh indecator

            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    readOnly: true,
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      hintText: 'Leave Start date',
                      icon: Icon(Icons.date_range),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: leave_start_date ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        setState(() {
                          leave_start_date = date;
                          _startDateController.text =
                              DateFormat.yMMMEd().format(date!);
                        });
                      });
                    },
                  ),
                  TextField(
                    readOnly: true,
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      hintText: 'Leave end date',
                      icon: Icon(Icons.date_range),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: leave_start_date ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        setState(() {
                          leave_end_date = date;
                          _endDateController.text =
                              DateFormat.yMMMEd().format(date!);
                        });
                      });
                    },
                  ),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: fileName),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.attach_file),
                    ),
                    onTap: () {
                      pickFile();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 2, right: 10),
                        child: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Color.fromARGB(255, 134, 134, 134),
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButton<String>(
                          value: type,
                          elevation: 16,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 48, 114, 236),
                            fontSize: 16,
                          ),
                          underline: Container(
                            height: 2,
                            color: Color.fromARGB(255, 80, 176, 255),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              type = newValue!;
                              dropdownValue = type;
                            });
                          },
                          items: [
                            "Sick",
                            "Casual",
                            "Maternity",
                            "Paternity",
                            "Bereavement",
                            "Compensatory"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Center(
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: RaisedButton(
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          AddLeave();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                'Add Leave',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                displacement: 50,
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: provider.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Container(
                    height: 150,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    child: SizedBox(
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CardLeave(
                          leave_start_date: provider[index]['leave_start_date'],
                          leave_end_date: provider[index]['leave_end_date'],
                          leave_days: provider[index]['leave_days'],
                          status: provider[index]['status'],
                          type: provider[index]['type'],
                          file: provider[index]['file'] ?? "",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
