import 'dart:io';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/ScreenBorder.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/Elements/TimeTable2.dart';
import 'package:facility_booking/model/SignInModel.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:facility_booking/screens/BookingDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:facility_booking/Elements/Constants.dart' as Constant;

class SignIn extends StatefulWidget {
  // passing parameters from booking time page
  final String Starttime;
  final String Endtime;
  SignIn(this.Starttime, this.Endtime, {Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future<SignInModel> SignInUser(
      String Username, String Password, context) async {
    final String pathUrl =
        'https://bobtest.optergykl.ga/hook/user/v1/authenticate';

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
    };

    var body = {
      "LoginID": Username,
      "Password": "aN2TJ2qJEF",
    };

    var response = await http.post(
      Uri.parse(pathUrl),
      headers: headers,
      body: jsonEncode(body), // use jsonEncode()
    );

    print("${response.statusCode}");
    print("${response.body}");


    if (response.statusCode != 200) {
      _errorlogin(context, );
    } else {
      _successfullogin(context, Username);
      return SignInModel.fromJson(json.decode(response.body));
    }
  }

  void _errorlogin(BuildContext context) {
    final alert = AlertDialog(
      title: Text("Error"),
      content: Text("Invalid username or password."),
      actions: [
        FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _successfullogin(BuildContext context, Username) {
    final alert = AlertDialog(
      title: Text("Successful"),
      content: Text("Successful login"),
      actions: [
        FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookingDetails(widget.Starttime, widget.Endtime, Username),
                ),
              );
            })
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();


  SignInModel _signIn;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              child: AvailableBorder(),
            ),
            // available text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Text('AVAILABLE',
                  style: new TextStyle(
                      fontSize: 80,
                      color: Constant.available,
                      fontWeight: FontWeight.bold)),
              alignment: Alignment(0, -0.7),
            ),


            // center box
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Container(
                height: 400,
                width: 600,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius:
                      BorderRadius.circular(30), //border corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                    //you can set more BoxShadow() here
                  ],
                ),
              ),
              alignment: Alignment(0, 0.3),
            ),

            //please sign in text
            Container(
              child: Text('PLEASE SIGN-IN',
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              alignment: Alignment(-0.4, -0.3),
            ),

            //username text box
            Container(
              padding: EdgeInsets.fromLTRB(180, 20, 580, 12),
              child: TextFormField(
                controller: UsernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Username is empty';
                  }
                  return null;
                },
              ),
              alignment: Alignment(-0.8, -0.1),
            ),

            // password text field
            Container(
              padding: EdgeInsets.fromLTRB(180, 60, 580, 12),
              child: TextFormField(
                controller: PasswordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Password is empty';
                  }
                  return null;
                },
              ),
              alignment: Alignment(-0.8, 0.15),
            ),

            // submit button
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: RaisedButton(
                onPressed: () async {
                  final String Username = UsernameController.text;
                  final String Password = PasswordController.text;

                  SignInModel signin =
                  await SignInUser(Username, Password, context);

                  setState(() {
                    _signIn = signin;
                  });
                  if (_formKey.currentState.validate()) {
                    final String Username = UsernameController.text;
                    final String Password = PasswordController.text;

                    SignInModel signin =
                        await SignInUser(Username, Password, context);

                    setState(() {
                      _signIn = signin;
                    });
                  }
                },
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color(0xFF2E368F)),
                  padding: const EdgeInsets.fromLTRB(80, 12, 80, 12),
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(0, 0.45),
            ),

            // time table
            Container(
              margin: EdgeInsets.fromLTRB(0, 250, 10, 10),
              child: TimeTable2(),
              alignment: Alignment.bottomRight,
            ),

            // Settings icon
            Container(
              child: Settings(),
              alignment: Alignment(-1, -1),
            ),

            //info
            Container(
              child: Info(),
              alignment: Alignment(1, -0.5),
            ),
            // time and date
            Container(
              child: TimeDate(),
              alignment: Alignment(1, -1),
            ),
            //Home Button
            Container(
              child: HomeButton(),
            )
          ],
        ),
      ),
    );
  }
}
