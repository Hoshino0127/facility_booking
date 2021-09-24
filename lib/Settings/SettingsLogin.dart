import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsLogin extends StatefulWidget {
  @override
  _SettingsLoginState createState() => _SettingsLoginState();
}

class _SettingsLoginState extends State<SettingsLogin> {

  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();


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
          body: Center(
            child: Stack(
               children: <Widget>[

                 // Center Box
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
                   alignment: Alignment(0, -0.3),
                 ),

                 //username text box
                 Container(
                   padding: EdgeInsets.fromLTRB(400, 12, 400, 12),
                   child: TextField(
                     controller: UsernameController,
                     decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       border: OutlineInputBorder(),
                       labelText: 'User Name',
                     ),
                   ),
                   alignment: Alignment(0, -0.1),
                 ),

                 // password text field
                 Container(
                   padding: EdgeInsets.fromLTRB(400, 12, 400, 12),
                   child: TextField(
                     controller: PasswordController,
                     decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       border: OutlineInputBorder(),
                       labelText: 'Password',
                     ),
                   ),
                   alignment: Alignment(-0.8, 0.15),
                 ),

                 // Confirm Button
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
                           colors: <Color>[Color(0xff00DBDD), Color(0xff4F7FFF)],
                         ),
                       ),
                       padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                       child: const Text('Submit', style: TextStyle(fontSize: 20)),
                     ),
                   ),
                   alignment: Alignment(-0.2, 0.3),
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
