import 'package:facility_booking/ApiService/test.dart';
import 'package:facility_booking/Elements/HomeButton.dart';
import 'package:facility_booking/Elements/PinValidation.dart';
import 'package:facility_booking/Elements/ScreenBorder.dart';
import 'package:facility_booking/screens/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class BookingTime extends StatefulWidget {
  @override
  _BookingTimeState createState() => _BookingTimeState();
}

class _BookingTimeState extends State<BookingTime> {
  double _height;
  double _width;
  DateTime date;
  TimeOfDay time;
  DateTime StartTime;
  DateTime EndTime;

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return null;
    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 00, minute: 00);

    final newTime = await showTimePicker(
      context: context,
      initialTime: StartTime != null
          ? TimeOfDay(hour: StartTime.hour, minute: StartTime.minute)
          : initialTime,
    );
    if (newTime == null) return null;
    return newTime;
  }

  Future pickStartTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;
    final time = await pickTime(context);
    if (time == null) return;
    setState(() {
      StartTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(StartTime);
    });
  }

  Future pickEndTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;
    final time = await pickTime(context);
    if (time == null) return;
    setState(() {
      EndTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  DateTime now = DateTime.now();

  String getStartText() {
    if (StartTime == null) {
      return "Select Start Time";
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(StartTime);
    }
  }

  String getEndText() {
    if (EndTime == null) {
      return 'Select End Time ';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(EndTime);
    }
  }

  // Alert Dialog if the time is null
  NullTimeDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enter Booking Time"),
      content: Text("Please enter the booking time to proceed"),
      actions: [
        okButton,
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

  //Confirm Booking Alert Dialog
  ConfirmBookingDialog(BuildContext context) {
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
        if (StartTime == null && StartTime == null) {
          NullTimeDialog(context);
        } else {
          final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          final String Starttime = formatter.format(StartTime);
          print(Starttime);

          final DateFormat formatter2 = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          final String Endtime = formatter2.format(EndTime);
          print(Endtime);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn(Starttime, Endtime),
            ),
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Confirm Booking?"),
      content: Text(
          "To commence meeting timely,15 minutes is required prior to complete booking confirmation.\n"
          "Proceed to confirm booking?\n"
          "*Note meeting will be delayed due to late booking confirmation"),
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Stack(children: <Widget>[
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
              alignment: Alignment(0, -0.7),
            ),

            // center box
            Container(
              margin: EdgeInsets.only(right: 400.0),
              child: Container(
                margin: EdgeInsets.all(20),
                height: 400,
                width: 700,
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
              alignment: Alignment(0, 0.4),
            ),

            // Start Time
            Container(
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    pickStartTime(context).then((value) => print(StartTime));
                  },
                  child: Text(getStartText()),
                ),
              ),
              alignment: Alignment(-0.25, 0),
            ),

            // End Time
            Container(
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    pickEndTime(context).then((value) => print(EndTime));
                  },
                  child: Text(getEndText()),
                ),
              ),
              alignment: Alignment(-0.25, 0.3),
            ),

            // submit button
            Container(
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ConfirmBookingDialog(context);
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
                      color: Color(0xFF2E368F)),
                  padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                  child: const Text('Submit', style: TextStyle(fontSize: 25)),
                ),
              ),
              alignment: Alignment(-0.45, 0.6),
            ),

            // cancel button
            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinPutTest(),
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
                    border: Border.all(color: Color(0xFF2E368F),width: 2.0),
                   color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                  child: const Text('Cancel', style: TextStyle(fontSize: 25,color: Colors.black)),
                ),
              ),
              alignment: Alignment(0, 0.6),
            ),

            // booking text
            Container(
              child: Text('BOOKING',
                  style: new TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              alignment: Alignment(-0.2, -0.25),
            ),

            // discussion text
            Container(
              child: Text('DISCUSSION',
                  style: new TextStyle(
                      fontSize: 33,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              alignment: Alignment(-0.8, 0.15),
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
          ])),
    );
  }
}
