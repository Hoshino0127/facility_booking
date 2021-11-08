import 'dart:io';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:facility_booking/screens/BookingDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
/*
// POST REQUEST TO SIGN IN
Future<SignInBooking> createBooking(String username) async {
  final http.Response response = await http.post(
    'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
    },
    body: jsonEncode(<String, String>{
      'CreatedUserFullName': username,
    }),
  );

  if (response.statusCode == 201) {
    return SignInBooking.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}


class SignInBooking {

  final String username;

  SignInBooking({this.username});

  factory SignInBooking.fromJson(Map<String, dynamic> json) {
    return SignInBooking(
      username: json['CreatedUserFullName'],
    );
  }
}*/


class SignIn extends StatefulWidget {

  // passing parameters from booking time page
  final String Starttime;
  final String Endtime;
  SignIn(this.Starttime,this.Endtime, {Key key}): super(key: key);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  /*Future<SignInBooking> _future;*/

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
            // available text
            Container(
              child: Text(
                  'AVAILABLE',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  )
              ),
              alignment: Alignment(-0.5, -0.7),
            ),

            // center box
            Container(
              child: Container(
                margin: EdgeInsets.all(20),
                height: 300,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30), //border corner radius
                  boxShadow:[
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
              alignment: Alignment(-0.65, 0),
            ),

            //please sign in text
            Container(
              child: Text(
                  'Please Sign-In',
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
              alignment: Alignment(-0.45, -0.3),
            ),

            //username text box
           Container(
                padding: EdgeInsets.fromLTRB(180, 12, 670, 12),
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
              padding: EdgeInsets.fromLTRB(180, 12, 670, 12),
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
              child: RaisedButton(
                onPressed: () {

                  setState(() {
                  /*  _future = createBooking(UsernameController.text);*/
                  });
                  if (_formKey.currentState.validate()) {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetails(widget.Starttime,widget.Endtime),
                    ),);
                  }
                },
                textColor: Colors.white,
                padding : EdgeInsets.fromLTRB(0,0,0,0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xff00DBDD), Color(0xff4F7FFF)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.2, 0.3),
            ),

            // time table
            Container(
              child: TimeTable(),
              alignment: Alignment(1, 1),
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

          ],
        ),
      ),
    );
  }
}
