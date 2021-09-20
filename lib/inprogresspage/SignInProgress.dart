import 'dart:io';
import 'package:facility_booking/inprogresspage/ManageMeeting.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<Booking> fetchBooking() async {
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/1'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
    },
  );

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Booking.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


class Booking {

  final String FacilityID;
  final String Starttime;
  final String Purpose;

  Booking({this.FacilityID, this.Starttime, this.Purpose});

  factory Booking.fromJson(Map<String, dynamic> json) {

    return Booking(
      FacilityID: json['FacilityID'],
      Starttime: json['StartDateTime'],
      Purpose: json['Purpose'],
    );
  }

}

class SignInProgress extends StatefulWidget {
  @override
  _SignInProgressState createState() => _SignInProgressState();
}

class _SignInProgressState extends State<SignInProgress> {

  Future<Booking> futureBooking;

  @override
  void initState() {
    super.initState();
    futureBooking = fetchBooking();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM \n  kk:mm:ss').format(now);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'IN PROGRESS',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.9),
            ),
            // meeting room text

            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<Booking>(
                future: futureBooking,
                builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    return Text(snapshot.data.FacilityID,
                      style: new TextStyle(
                          fontSize: 60,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              alignment: Alignment(0, -0.6),
            ),

            // time text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  '12.30PM - 2.30PM',
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.4),
            ),

            // description text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<Booking>(
                future: futureBooking,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.Purpose,
                      style: new TextStyle(
                          fontSize: 30,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              alignment: Alignment(0, -0.2),
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
                      color: Colors.white.withOpacity(0.5),//color of shadow
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
              alignment: Alignment(-0.4, 1),
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
              alignment: Alignment(-0.3, 0.2),
            ),

            // username text field
            Container(
              padding: EdgeInsets.fromLTRB(280, 12, 600, 12),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
              alignment: Alignment(-0.8, 0.4),
            ),

            // password textfield
            Container(
              padding: EdgeInsets.fromLTRB(280, 12, 600, 12),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              alignment: Alignment(-0.8, 0.65),
            ),

            // submit button
            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageMeeting()
                    ),);
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
              alignment: Alignment(-0.08, 0.85),
            ),


            // time table
            Container(
              child: Table(
                defaultColumnWidth: FixedColumnWidth(200.0),
                border: TableBorder.all(color: Colors.grey,width: 2.0),
                children: [
                  TableRow(
                      children: [
                        Text("11.00am",style: TextStyle(fontSize: 35.0, color: Colors.grey, ),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("11.30am",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("2.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                ],
              ),
              alignment: Alignment(1, 1),
            ),
            // settings
            Container(
              child: Icon(
                  Icons.info, color: Colors.black, size: 100.0
              ),
              alignment: Alignment(1,-0.5),
            ),

            // time and date
            Container(
              child: Text(
                  formattedDate,
                  style: new TextStyle(
                    fontSize: 40,
                    color: Colors.grey,

                  )
              ),
              alignment: Alignment(1,-1),
            ),
          ],
        ),
      ),
    );
  }
}
