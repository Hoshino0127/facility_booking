import 'dart:io';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/Elements/TimeTable2.dart';
import 'package:facility_booking/model/SignInModel.dart';
import 'package:facility_booking/pendingpage/CancelBooking.dart';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignInCancel extends StatefulWidget {
  final String Bkey;
  SignInCancel(this.Bkey, {Key key}) : super(key: key);
  @override
  _SignInCancelState createState() => _SignInCancelState();
}

class _SignInCancelState extends State<SignInCancel> {

  Future<SignInModel> SignInUser(
      String Username, String Password, context) async {
    final String pathUrl =
        'https://bobtest.optergykl.ga/hook/user/v1/authenticate';

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
    };

    var body = {
      "LoginID": "Xenber",
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
      _errorlogin(context);
    } else {
      _successfullogin(context);
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

  void _successfullogin(BuildContext context) {
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
                     CancelBooking(widget.Bkey),
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

  SignInModel _signIn;

  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrangeAccent, //                   <--- border color
                  width: 7.0,
                ),
              ),
            ),
            // pending confirmation text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Text(
                  'PENDING \n CONFIRMATION',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.9),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CancelBooking(widget.Bkey),
                    ),
                  );

                  /*  final String Username = UsernameController.text;
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
                  }*/
                },
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color(0xFF2E368F)
                  ),
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
              alignment: Alignment(-1,-  1),
            ),

            //info
            Container(
              child: Info(),
              alignment: Alignment(1,-0.5),
            ),

            // time and date
            Container(
              child: TimeDate(),
              alignment: Alignment(1,-1),
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
