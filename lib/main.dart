import 'dart:io';
import 'package:facility_booking/Elements/ScreenBorder.dart';
import 'package:facility_booking/Elements/TimeTable2.dart';
import 'package:facility_booking/model/SettingsModel.dart';
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
import 'package:facility_booking/Database/SettingsDB.dart';
import 'model/LocationModel.dart';
import 'package:facility_booking/Elements/Constants.dart' as Constant;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  final primarycolor = Color(0xFF2E368F);
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Arial',
        primaryColor: primarycolor,
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
  Future<Locations> futureLocation;
  String EndTime;
  String a = Constant.Location_Key;
  Future<Locations> fetchLocation() async {
    final response = await http.get(
      Uri.parse(
          'https://bobtest.optergykl.ga/lucy/location/v1/locations/$a'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      },
    );

    // Appropriate action depending upon the
    // server response
    if (response.statusCode == 200) {
      return Locations.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Setting>> getSettings() async {
    Future<List<Setting>> key = DbManager.db.getSettings();
    return key;
  }

  @override
  void initState() {
    super.initState();
    futureLocation = fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Stack(children: <Widget>[
        Container(
          child: AvailableBorder(),
        ),
        Container(
          margin: EdgeInsets.only(right: 400.0),
          width: double.infinity,
          child: Text(
            'AVAILABLE',
            style: new TextStyle(
                fontSize: 80, color: Constant.available, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment(0, -0.6),
        ),

        Container(
          margin: EdgeInsets.only(right: 400.0),
          width: double.infinity,
          child: FutureBuilder<Locations>(
            future: futureLocation,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.locationFullName,
                  style: new TextStyle(
                      fontSize: 60,
                      color: Color(0xFF2E368F),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              } else if (snapshot.hasError) {
                return Text('');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          alignment: Alignment(0, -0.2),
        ),
        FutureBuilder<List<Setting>>(
            future: getSettings(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  EndTime = snapshot.data[0].EndTime;
                  return Container(
                    margin: EdgeInsets.only(right: 300.0),
                    width: double.infinity,
                    child: Text(
                      'Available Until $EndTime',
                      style: new TextStyle(
                          fontSize: 40,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment(-0.1, 0.15),
                  );
                }
              }
              return Container(
                margin: EdgeInsets.only(right: 400.0),
                width: double.infinity,
                child: Text(
                  'Available Until Null',
                  style: new TextStyle(
                      fontSize: 40,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment(0, 0.15),
              );
            }),
        Container(
          margin: EdgeInsets.only(right: 400.0),
          width: double.infinity,
          child: Text(
            'Next Meeting : ',
            style: new TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment(0, 0.3),
        ),
        Container(
          margin: EdgeInsets.only(right: 400.0),
          width: double.infinity,
          child: Text(
            '12.30pm - 3.30pm',
            style: new TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment(0, 0.4),
        ),

        Container(
          margin: EdgeInsets.only(right: 400.0),
          width: double.infinity,
          child: Text(
            'Hosted By John',
            style: new TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment(0, 0.5),
        ),

        Container(
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingTime(),
                ),
              );
            },
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
               color: Color(0xFF2E368F),
              ),
              padding: const EdgeInsets.fromLTRB(100, 12, 100, 12),
              child: const Text('Book', style: TextStyle(fontSize: 30)),
            ),
          ),
          alignment: Alignment(-0.4, 0.7),
        ),

        Container(
          child: TimeDate(),
          alignment: Alignment(1, -1),
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

        Container(
          child: Info(),
          alignment: Alignment(1, -0.5),
        ),
      ])),
    );
  }
}
