import 'dart:io';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
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
  final String HostName;

  Booking({this.FacilityID, this.Starttime, this.Purpose, this.HostName});

  factory Booking.fromJson(Map<String, dynamic> json) {

    return Booking(
      FacilityID: json['FacilityID'],
      Starttime: json['StartDateTime'],
      Purpose: json['Purpose'],
      HostName: json['HostUserFullName'],
    );
  }

}

class ManageMeeting extends StatefulWidget {
  @override
  _ManageMeetingState createState() => _ManageMeetingState();
}

class _ManageMeetingState extends State<ManageMeeting> {

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
      appBar: AppBar(),
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

            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<Booking>(
                future: futureBooking,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Hosted By ' + snapshot.data.HostName,
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
              alignment: Alignment(0, 0),
            ),

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
                  child: const Text(' Extend Booking ', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.29, 0.2),
            ),

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
                  child: const Text('Release Booking', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.29, 0.4),
            ),
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
                  child: const Text('       Cancel         ', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.29, 0.6),
            ),
            // time table
            Container(
              child: Table(
                defaultColumnWidth: FixedColumnWidth(150.0),
                border: TableBorder.all(color: Colors.lightBlueAccent,width: 2.0),
                children: [
                  TableRow(
                      children: [
                        Text("11.00",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("11.30",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.00",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.30",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.00",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.30",style: TextStyle(fontSize: 50.0),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("2.00",style: TextStyle(fontSize: 50.0),),
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
