import 'dart:io';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/TimeTable.dart';


Future<Booking> fetchBooking() async {
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/7'),
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
  final String Endtime;

  Booking({this.FacilityID,this.Starttime,  this.Endtime});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      FacilityID: json['FacilityID'],
      Starttime: json['StartDateTime'],
      Endtime: json['EndDateTime'],
    );
  }
}

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  Future<Booking> futureBooking;


  @override
  void initState() {
    super.initState();
    futureBooking = fetchBooking();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
       child: Stack(
           children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 300.0),
            width: double.infinity,
            child: Text(
                'AVAILABLE',
                style: new TextStyle(
                    fontSize: 60,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              textAlign: TextAlign.center,
                ),
            alignment: Alignment(0, -0.5),
            ),

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
               alignment: Alignment(0, -0.3),
             ),

             Container(
               margin: EdgeInsets.only(right: 300.0),
               width: double.infinity,
               child: Text(
                   'Available Until 12.30 PM',
                   style: new TextStyle(
                       fontSize: 40,
                       color: Colors.grey,
                       fontWeight: FontWeight.bold
                   ),
                 textAlign: TextAlign.center,
               ),
               alignment: Alignment(0, -0.1),
             ),
             Container(
               margin: EdgeInsets.only(right: 300.0),
               width: double.infinity,
               child: Text(
                   'Next Meeting : ',
                   style: new TextStyle(
                       fontSize: 20,
                       color: Colors.grey,
                   ),
                 textAlign: TextAlign.center,
               ),
               alignment: Alignment(0, 0.1),
             ),
             Container(
               margin: EdgeInsets.only(right: 300.0),
               width: double.infinity,
               child: Text(
                   '12.30pm - 3.30pm',
                   style: new TextStyle(
                     fontSize: 20,
                     color: Colors.grey,
                   ),
                 textAlign: TextAlign.center,
               ),
               alignment: Alignment(0, 0.2),
             ),


             Container(
               margin: EdgeInsets.only(right: 300.0),
               width: double.infinity,
               child: Text(
                   'Hosted By John',
                   style: new TextStyle(
                     fontSize: 20,
                     color: Colors.grey,
                   ),
                 textAlign: TextAlign.center,
               ),
               alignment: Alignment(0, 0.3),
             ),

             Container(
               child: RaisedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => BookingTime(),
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
                   child: const Text('Book', style: TextStyle(fontSize: 20)),
                 ),
               ),
               alignment: Alignment(-0.27, 0.5),
             ),

             Container(
               child: TimeDate(),
               alignment: Alignment(1,-1),
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

             Container(
               child: Info(),
               alignment: Alignment(1,-0.5),
             ),
           ]
       )
      ),
    );
  }
}
