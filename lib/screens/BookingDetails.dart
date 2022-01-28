import 'dart:convert';
import 'dart:io';
import 'package:facility_booking/ApiService/BookingModel.dart';
import 'package:facility_booking/Database/SettingsDB.dart';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/ScreenBorder.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/inprogresspage/SignInProgress.dart';
import 'package:facility_booking/main.dart';
import 'package:facility_booking/model/SettingsModel.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:facility_booking/pendingpage/SignInCancel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingDetails extends StatefulWidget {
  final String Starttime;
  final String Endtime;
  final String Username;
  BookingDetails(this.Starttime, this.Endtime,this.Username, {Key key}) : super(key: key);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  Future<List<Setting>> getSettings() async {
    Future<List<Setting>> key = DbManager.db.getSettings();
    return key;
  }

  Future<BookingModel> createBooking(context, String Starttime,
      String Endtime, String Details, String Lkey) async {
    print(widget.Username);
    final String pathUrl =
        'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings';

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
    };

    var body = {
      "LocationKey": Lkey,
      "StartDateTime": Starttime,
      "EndDateTime": Endtime,
      "Purpose": Details,
      "HostObjectKey": "1",
      "HostObjectType": "Organization.OrgStaff",
      "HostUserFullName": widget.Username,
    };

    var response = await http.post(
      Uri.parse(pathUrl),
      headers: headers,
      body: jsonEncode(body), // use jsonEncode()
    );

    print("${response.statusCode}");
    print("${response.body}");

    if (response.statusCode != 200) {
      _errorCreate(context, response);
    } else {
      _successfulCreate(context);
    }
  }

  void _errorCreate(BuildContext context, response) {
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

  void _successfulCreate(BuildContext context) {
    final alert = AlertDialog(
      title: Text("Successful"),
      content: Text("A booking has been created"),
      actions: [
        FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
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

  TextEditingController HostController = TextEditingController();
  TextEditingController DetailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  BookingModel _booking;
  static String Lkey;
  String Bkey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              child: AvailableBorder(),
            ),
            // available text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Text('AVAILABLE',
                  style: new TextStyle(
                      fontSize: 80,
                      color: Color(0xFF2E368F),
                      fontWeight: FontWeight.bold)),
              alignment: Alignment(0, -0.8),
            ),

            FutureBuilder<List<Setting>>(
                future: getSettings(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.hasData) {
                      Lkey = snapshot.data[0].Lkey;
                      print(Lkey);
                      return Text(
                        Lkey,
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  }
                  return Text("");
                }),

            // center box
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Container(
                margin: EdgeInsets.all(20),
                height: 500,
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
              alignment: Alignment(0, 0.8),
            ),


            // Booking Details
            Container(
              padding: EdgeInsets.fromLTRB(180, 30, 580, 12),
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
              alignment: Alignment(-0.8, 0.2),
            ),

            // submit button
            Container(
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final String Details = DetailsController.text;
                    final String Starttime = widget.Starttime;
                    final String Endtime = widget.Endtime;

                    BookingModel booking = await createBooking(
                        context, Starttime, Endtime, Details, Lkey);

                    setState(() {
                      _booking = booking;
                    });
                  }
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
                  padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.5, 0.7),
            ),

            // cancel button
            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),);
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
                  padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                  child: const Text('Cancel', style: TextStyle(fontSize: 20,color: Colors.black)),
                ),
              ),
              alignment: Alignment(-0.15, 0.7),
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
          ],
        ),
      ),
    );
  }
}
