import 'dart:io';
import 'package:facility_booking/ApiService/BookingModel.dart';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/ScreenBorder.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/inprogresspage/MeetingInProgress.dart';
import 'package:facility_booking/model/BookingModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ApiService/ApiFunction.dart' as api;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../main.dart';

class CancelBooking extends StatefulWidget {
  final String Bkey;
  CancelBooking(this.Bkey, {Key key}) : super(key: key);
  @override
  _CancelBookingState createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {
  Future<BookingModel> fetchBooking() async {
    final String key = widget.Bkey;
    final response = await http.get(
      Uri.parse(
          'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/$key'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      },
    );

    // Appropriate action depending upon the
    // server response
    if (response.statusCode == 200) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Booking> DeleteBooking() async {
    final String key = widget.Bkey;
    final String pathUrl =
        'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/$key';

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
    };

    var response = await http.delete(
      Uri.parse(pathUrl),
      headers: headers, // use jsonEncode()
    );
    print("${response.statusCode}");
    print("${response.body}");

    if (response.statusCode != 200) {
      _errorDelete(context, response);
    } else {
      _successfulConfirm(context);
    }
  }


  void _errorDelete(BuildContext context, response ) {
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

  void _successfulConfirm(BuildContext context) {
    final alert = AlertDialog(
      title: Text("Successful"),
      content: Text("A booking has been deleted"),
      actions: [
        FlatButton(
            child: Text("OK"),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(),
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

  Booking _deleteBook;

  DeleteBookingDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        Booking deleteBook = await DeleteBooking();

        setState(() {
          _deleteBook = deleteBook;
        });
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInCancel(),
          ),);*/
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want delete this booking?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
  String Bkey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                child: PendingBorder(),
              ),
              // pending confirmation text
              Container(
                margin: EdgeInsets.only(right: 300.0),
                width: double.infinity,
                child: Text('PENDING \n CONFIRMATION',
                    style: new TextStyle(
                        fontSize: 60,
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                alignment: Alignment(0, -0.9),
              ),

              // meeting room text
              Container(
                margin: EdgeInsets.only(right: 300.0),
                width: double.infinity,
                child: FutureBuilder<BookingModel>(
                  future: fetchBooking(),
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
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                alignment: Alignment(0, -0.4),
              ),

              // time text
              Container(
                margin: EdgeInsets.only(right: 300.0),
                width: double.infinity,
                child: FutureBuilder<BookingModel>(
                  future: fetchBooking(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DateTime parseDate =
                          new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                              .parse(snapshot.data.startDateTime);
                      var inputDate = DateTime.parse(parseDate.toString());
                      var outputFormat = DateFormat('hh:mm a');
                      var StartTime = outputFormat.format(inputDate);

                      DateTime parseDate2 =
                          new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                              .parse(snapshot.data.endDateTime);
                      var inputDate2 = DateTime.parse(parseDate2.toString());
                      var outputFormat2 = DateFormat('hh:mm a');
                      var Endtime = outputFormat2.format(inputDate2);

                      return Text(
                        (StartTime + " - " + Endtime),
                        style: new TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
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

              // description text
              Container(
                margin: EdgeInsets.only(right: 300.0),
                width: double.infinity,
                child: FutureBuilder<BookingModel>(
                  future: fetchBooking(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.purpose,
                        style: new TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                alignment: Alignment(0, 0.2),
              ),

              /* // next meeting text
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
              alignment: Alignment(0, 0.2),
            ),

            // time text
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
              alignment: Alignment(0, 0.3),
            ),

            // host text
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
              alignment: Alignment(0, 0.4),
            ), */

              // center box
              Container(
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 150,
                  width: 300,
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
                alignment: Alignment(-0.33, 0.9),
              ),

              // cancel text
              Container(
                child: Text('Are you sure you want \n to cancel your booking',
                    style: new TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center),
                alignment: Alignment(-0.3, 0.6),
              ),

              Container(
                child: RaisedButton(
                  onPressed: () {
                   DeleteBookingDialog(context);
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
                    padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                    child: const Text('Yes', style: TextStyle(fontSize: 20)),
                  ),
                ),
                alignment: Alignment(-0.36, 0.78),
              ),

              Container(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MeetingInProgress(Bkey)));
                  },
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    padding: const EdgeInsets.fromLTRB(35, 12, 35, 12),
                    child: const Text('No', style: TextStyle(fontSize: 20)),
                  ),
                ),
                alignment: Alignment(-0.18, 0.78),
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
        ));
  }
}
