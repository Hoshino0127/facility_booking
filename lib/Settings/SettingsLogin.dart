import 'dart:io';

import 'package:facility_booking/Settings/SettingsPage.dart';
import 'package:facility_booking/model/SignInModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SettingsLogin extends StatefulWidget {
  @override
  _SettingsLoginState createState() => _SettingsLoginState();
}

class _SettingsLoginState extends State<SettingsLogin> {

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
                  builder: (context) => SettingsPage(),
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
  final _formKey = GlobalKey<FormState>();
  SignInModel _signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
          'LOGIN',
            style: new TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
        ),
        ),
        ),
          body: Form(
            key: _formKey,
            child: Stack(
               children: <Widget>[
                 // Center Box
                 Container(
                   child: Container(
                     margin: EdgeInsets.all(20),
                     height: 400,
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
                   alignment: Alignment.center
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
                   alignment: Alignment(0, -0.4),
                 ),

                 //username text box
                 Container(
                   padding: EdgeInsets.fromLTRB(400, 12, 400, 12),
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
                   alignment: Alignment(0, -0.2),
                 ),


                 // password text field
                 Container(
                   padding: EdgeInsets.fromLTRB(400, 12, 400, 12),
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
                   alignment: Alignment(-0.8, 0.05),
                 ),


                 // Confirm Button
                 Container(
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
                       child: const Text('Submit', style: TextStyle(fontSize: 20)),
                     ),
                   ),
                   alignment: Alignment(-0.15, 0.3),
                 ),

                 // cancel button
                 Container(
                   child: RaisedButton(
                     onPressed: () {

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
                           colors: <Color>[Color(0xffD3D3D3), Color(0xff9E9E9E)],
                         ),
                       ),
                       padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                       child: const Text('Cancel', style: TextStyle(fontSize: 20)),
                     ),
                   ),
                   alignment: Alignment(0.2, 0.3),
                 ),

               ],
            ),

    ),
    );
  }
}
