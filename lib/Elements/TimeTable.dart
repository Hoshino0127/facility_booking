import 'dart:io';
import 'package:facility_booking/inprogresspage/MeetingInProgress.dart';
import 'package:facility_booking/inprogresspage/SignInProgress.dart';
import 'package:facility_booking/model/BookingModel.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:facility_booking/pendingpage/SignInCancel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

Future<List<Booking>> fetchBooking() async {
  var response = await http.get(
      Uri.parse(
          'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings?LocationKey=23&StartDateTime=$time11'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      });

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Booking.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

final now = new DateTime.now();
String formatter = DateFormat('yyyy-MM-dd').format(now);
String time11 = "${formatter}T11:00:00Z";
String time1130 = "${formatter}T11:30:00Z";
String time12 = "${formatter}T12:00:00Z";
String time1230 = "${formatter}T12:30:00Z";
String time13 = "${formatter}T13:00:00Z";
String time1330 = "${formatter}T13:30:00Z";
String time14 = "${formatter}T14:00:00Z";
String time1430 = "${formatter}T14:30:00Z";

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Future<List<Booking>> futureBooking;
  String Bkey;

  PendingDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Confirm Booking"),
      onPressed: () {
        print(Bkey);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadyToStart(Bkey),
          ),
        );
      },
    );
    Widget continueButton = TextButton(
      child: Text("Cancel Booking"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInCancel(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text(
          "Would you like to confirm or cancel current selected booking??"),
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

  BookedDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInCancel(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text("Would you like to cancel current selected booking??"),
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

  InProgressDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInProgress(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text("Would you like to view current selected booking??"),
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
    futureBooking = fetchBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        defaultColumnWidth: FixedColumnWidth(200.0),
        border: TableBorder.all(color: Colors.grey, width: 2.0),
        children: [
          TableRow(
            children: [
              Text(
                "11.00am",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time11 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time11 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF2E368F)),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time11 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "11.30am",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time1130 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time1130 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time1130 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "12.00pm",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time12 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time12 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time12 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "12.30pm",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time1230 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time1230 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time1230 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "1.00pm",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time13 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time13 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time13 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "1.30pm",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time1330 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time1330 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time1330 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
          TableRow(
            children: [
              Text(
                "2.00pm",
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.grey,
                ),
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: FutureBuilder<List<Booking>>(
                      future: futureBooking,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  String starttime = snapshot
                                      .data[index].startDateTime
                                      .toString();
                                  String stage =
                                      snapshot.data[index].stage.toString();
                                  String bookingkey = snapshot
                                      .data[index].bookingKey
                                      .toString();
                                  Bkey = bookingkey;
                                  if (time14 == starttime &&
                                      stage == "Pending") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrangeAccent),
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => PendingDialog(context),
                                    );
                                  } else if (time14 == starttime &&
                                      stage == "Finalized") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text('Booked',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => BookedDialog(context),
                                    );
                                  } else if (time14 == starttime &&
                                      stage == "InProgress") {
                                    return InkWell(
                                      child: Container(
                                          width: 200,
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Text('In Progress',
                                              style: TextStyle(
                                                fontSize: 35.0,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center)),
                                      onTap: () => InProgressDialog(context),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                }),
                          );
                        }
                      }))
            ],
          ),
        ],
      ),
      alignment: Alignment(0.98, 0.95),
    );
  }
}
