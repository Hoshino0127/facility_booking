
import 'dart:convert';
import 'dart:io';
import 'package:facility_booking/model/UserKeyModel.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'HomeButton.dart';
import 'Info.dart';
import 'ScreenBorder.dart';
import 'Settings.dart';
import 'TimeDate.dart';
import 'TimeTable.dart';
import 'package:http/http.dart' as http;
import 'package:facility_booking/Elements/Constants.dart' as Constant;

class PinPutTest extends StatefulWidget {
  @override
  _PinPutTestState createState() => _PinPutTestState();
}

class _PinPutTestState extends State<PinPutTest> {


  Future<UserKeyModel> pinValidation(context) async {
    final response = await http.get(
      Uri.parse(
          'https://bobtest.optergykl.ga/lucy/user/v1/validatepin?PINCode=$pin'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      },
    );
    print("${response.statusCode}");
    print("${response.body}");
    // Appropriate action depending upon the
    // server response
    if (response.statusCode == 200) {
      return UserKeyModel.fromJson(json.decode(response.body));
    } else {
      _errorCreate(context, response);
    }
  }
  void _errorCreate(BuildContext context,response) {
    final alert = AlertDialog(
      title: Text("Error"),
      content: Text("${response.body}"),
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


  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String pin;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color(0xFF2E368F)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
          child: Stack(children: <Widget>[

            Container(
              child: AvailableBorder(),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50,200,500,400),
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: PinPut(

                fieldsCount: 6,
                onSubmit: (String pin) => _showSnackBar(pin, context),
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                textStyle: const TextStyle(fontSize: 40.0, color: Colors.black),
                submittedFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                selectedFieldDecoration: _pinPutDecoration,
                followingFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Color(0xFF2E368F),width: 3.0,
                  ),
                ),
              ),
            ),
            // submit button
            Container(
              child: RaisedButton(
                onPressed: () async{
                  pin = _pinPutController.text;
                  await pinValidation(context);
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
                  padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                  child: const Text('Submit', style: TextStyle(fontSize: 25)),
                ),
              ),
              alignment: Alignment(-0.7, 0.6),
            ),

            // cancel button
            Container(
              child: RaisedButton(
                onPressed: () {
                  _pinPutController.text = "";
                },
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Color(0xFF2E368F),width: 2.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                  child: const Text('Clear All', style: TextStyle(fontSize: 25,color: Colors.black)),
                ),
              ),
              alignment: Alignment(-0.2, 0.6),
            ),
            // time table
            Container(
              child: TimeTable(),
              alignment: Alignment(1, 1),
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
          ])),
    );
  }
}

void _showSnackBar(String pin, BuildContext context) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    content: Container(
      height: 80.0,
      child: Center(
        child: Text(
          'Pin Submitted. Value: $pin',
          style: const TextStyle(fontSize: 25.0),
        ),
      ),
    ),
    backgroundColor: Colors.deepPurpleAccent,
  );
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
