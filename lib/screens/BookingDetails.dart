import 'dart:convert';
import 'dart:io';
import 'package:facility_booking/ApiService/BookingModel.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingDetails extends StatefulWidget {
  final DateTime StartTime;
  final DateTime EndTime;
  BookingDetails(this.StartTime,this.EndTime, {Key key}): super(key: key);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}


Future<BookingModel> createBooking(String Hostname, /*String StartTime, String EndTime, */String Details )async {

final String pathUrl = 'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings';

var headers = {
  'Content-Type': 'application/json',
  HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
};

var body = {
  "LocationKey": "23",
  "StartDateTime" : "2021-10-27T10:30:00Z",
  "EndDateTime": "2021-10-27T11:00:00Z",
  "Purpose": Details,
  "HostObjectKey": "1",
  "HostObjectType": "Organization.OrgStaff",
  "HostUserFullName": Hostname,

};

var response = await http.post(Uri.parse(pathUrl),
  headers: headers,
  body: jsonEncode(body), // use jsonEncode()
);

if (response.statusCode == 200) {
  print("${response.statusCode}");
} else {
  throw Exception('Failed to load album');
}
  print("${response.statusCode}");
  print("${response.body}");
}



class _BookingDetailsState extends State<BookingDetails> {

  TextEditingController HostController = TextEditingController();
  TextEditingController DetailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  BookingModel _booking;


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
                height: 500,
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
              alignment: Alignment(-0.65, 0.4),
            ),

            //HostName text box
            Container(
              padding: EdgeInsets.fromLTRB(180, 12, 670, 12),
              child: TextFormField(
                controller: HostController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Host Name',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Host Name is empty';
                  }
                  return null;
                },
              ),
              alignment: Alignment(-0.8, -0.4),
            ),

            //
            Container(
              padding:  EdgeInsets.fromLTRB(180, 12, 670, 12),
              child: TextFormField(
                controller: DetailsController,
                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Booking Details',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Booking Details is empty';
                  }
                  return null;
                },
              ),
              alignment: Alignment(-0.8, 0.1),
            ),

            // submit button
            Container(
              child: RaisedButton(
                onPressed: ()async {
                  if (_formKey.currentState.validate()) {
                   final String Hostname = HostController.text;
                   final String Details = DetailsController.text;
                  /* final String StartTime = widget.StartTime;
                   final String EndTime = widget.EndTime;*/

                   BookingModel booking = await createBooking(Hostname, Details);

                   setState(() {
                     _booking = booking;
                   });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadyToStart(),
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
              alignment: Alignment(-0.6, 0.55),
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
              alignment: Alignment(-0.25, 0.55),
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
