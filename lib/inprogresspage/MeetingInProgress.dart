import 'dart:io';
import 'package:facility_booking/ApiService/BookingModel.dart';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/inprogresspage/SignInProgress.dart';
import 'package:facility_booking/main.dart';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../ApiService/ApiFunction.dart' as api;

class MeetingInProgress extends StatefulWidget {
  final String Bkey;
  MeetingInProgress(this.Bkey, {Key key}) : super(key: key);
  @override
  _MeetingInProgressState createState() => _MeetingInProgressState();
}

class _MeetingInProgressState extends State<MeetingInProgress> {
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
  BookSession(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingTime(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to book another session?"),
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

  Future<BookingModel> ReleaseBooking() async {
    final String key = widget.Bkey;
    final String pathUrl =
        'http://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/$key/end';

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
      _errorRelease(context, response);
    } else {
      _successfulRelease(context);
    }
  }


  void _errorRelease(BuildContext context, response ) {
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

  void _successfulRelease(BuildContext context) {
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

  BookingModel _releaseBook;

  ReleaseBookingDialog(BuildContext context) {
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
        BookingModel releaseBook = await ReleaseBooking();

        setState(() {
          _releaseBook = releaseBook;
        });

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to release this booking?"),
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM \n  kk:mm:ss').format(now);
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red, //                   <--- border color
                  width: 7.0,
                ),
              ),
            ),
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
              alignment: Alignment(0, -0.7),
            ),

            // meeting room text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              width: double.infinity,
              child: FutureBuilder<BookingModel>(
                future: fetchBooking(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.locationFullName,
                      style: new TextStyle(
                          fontSize: 60,
                          color: Color(0xFF2E368F),
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}',
                    );
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              alignment: Alignment(0, -0.4),
            ),

            // time text
            Container(
              margin: EdgeInsets.only(right: 400.0),
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
              alignment: Alignment(0, 0.3),
            ),

            // description text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              width: double.infinity,
              child: FutureBuilder<BookingModel>(
                future: fetchBooking(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.purpose,
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
              alignment: Alignment(0, 0.1),
            ),

            // next meeting text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              width: double.infinity,
              child: Text(
                  'Next Meeting : ',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, 0.4),
            ),

            // time text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              width: double.infinity,
              child: Text(
                  '12.30pm - 3.30pm',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, 0.5),
            ),

            // host text
            Container(
              margin: EdgeInsets.only(right: 400.0),
              width: double.infinity,
              child: Text(
                  'Hosted By John',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, 0.6),
            ),

            // Book button
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: RaisedButton(
                onPressed: () {
                  BookSession(context);
                },
                textColor: Colors.white,
                padding : EdgeInsets.fromLTRB(0,0,0,0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                      color: Color(0xFF2E368F)
                  ),
                  padding: const EdgeInsets.fromLTRB(100, 12, 100, 12),
                  child: const Text('Book', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.5, 0.8),
            ),

            // Release button
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: RaisedButton(
                onPressed: () {
                  ReleaseBookingDialog(context);
                },
                textColor: Colors.white,
                padding : EdgeInsets.fromLTRB(0,0,0,0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color(0xFF2E368F)
                  ),
                  padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                  child: const Text('Release Booking', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(0.5, 0.8),
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
