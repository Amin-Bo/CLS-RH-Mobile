// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cls_rh/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'dart:convert';

import 'components/bottom_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();

  signin(String email, String password) async {
    email.trimLeft();
    email.trimRight();
    var body = jsonEncode({'email': email.trim(), 'password': password.trim()});
    print(body);
    String msg = "";
    Uri url = Uri.parse(cls_URL + "api/employee/login");
    var jsonResponse;
    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    jsonResponse = json.decode(res.body);
    if (res.statusCode == 200) {
      // print("response status = ${res.statusCode}");
      // print("response body = ${res.body}");
    }
    if (jsonResponse == 200) {
      setState(() {
        _isLoading == false;
      });
    } else {
      setState(() {
        //print(jsonResponse);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse["message"]),
        ));
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("_id", jsonResponse["user"]['_id']);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext) => HomeScreen()));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: BgColor,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          //padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width * 0.3,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 20)),
                    Text(
                      'CLS-RH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' RH System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/log.png',
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  color: BgColor,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _EmailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  color: BgColor,
                  child: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _PasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 109, 189, 255),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            signin(_EmailController.text.trim(),
                                _PasswordController.text.trim());
                          },
                          child: Row(
                            children: [
                              Text(
                                "Login ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Icons.login_outlined,
                                color: Color.fromARGB(255, 255, 252, 252),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
