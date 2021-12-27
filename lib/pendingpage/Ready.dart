import 'package:facility_booking/ApiService/BookingModel.dart';
import 'package:facility_booking/Elements/Info.dart';
import 'package:facility_booking/Elements/Settings.dart';
import 'package:facility_booking/Elements/TimeDate.dart';
import 'package:facility_booking/Elements/TimeTable.dart';
import 'package:facility_booking/pendingpage/SignInCancel.dart';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ApiService/ApiFunction.dart' as api;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ReadyToStart extends StatefulWidget {
  @override
  _ReadyToStartState createState() => _ReadyToStartState();
}

Future<BookingModel> confirmBooking() async{
  final String pathUrl = 'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/899/confirm';

  var headers = {
    'Content-Type': 'application/json',
    HttpHeaders.authorizationHeader:'SC:epf:0109999a39c6f102',
  };

  var body = {
  "Stage": "Confirmed",
};

  var response = await http.patch(Uri.parse(pathUrl),
    headers: headers,
    body: jsonEncode(body), // use jsonEncode()

  );

  print("${response.statusCode}");
  print("${response.body}");
}

class _ReadyToStartState extends State<ReadyToStart> {

  @override
  void initState() {
    super.initState();
  }

  BookingModel _confirmBook;

  ConfirmBookingDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue"),
        onPressed: () async {
        /*
        BookingModel confirmBook = await confirmBooking();

        setState(() {
         _confirmBook = confirmBook;
        });*/
        Navigator.push(
        context,
        MaterialPageRoute(
           builder: (context) => SignInCancel(),
           ),);
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Confirm Booking?"),
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

  BookSession(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: ()  {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingTime(),
          ),);
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
     appBar: AppBar(

     ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            // pending confirmation text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'PENDING \n CONFIRMATION',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.9),
            ),

            // Facility Name
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<api.Booking>(
                future: api.fetchBooking(),
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
              alignment: Alignment(0, -0.4),
            ),
            

            // time text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<api.Booking>(
                future: api.fetchBooking(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                  {

                    DateTime parseDate =
                    new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(snapshot.data.Starttime);
                    var inputDate = DateTime.parse(parseDate.toString());
                    var outputFormat = DateFormat('hh:mm a');
                    var StartTime = outputFormat.format(inputDate);

                    DateTime parseDate2 =
                    new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(snapshot.data.Endtime);
                    var inputDate2 = DateTime.parse(parseDate2.toString());
                    var outputFormat2 = DateFormat('hh:mm a');
                    var Endtime = outputFormat2.format(inputDate2);

                    return Text((StartTime +" - "+ Endtime ),
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

            // Booking Description
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<api.Booking>(
                future: api.fetchBooking(),
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
              alignment: Alignment(0, 0),
            ),

            // next meeting text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'Next Meeting : ',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center
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
                  textAlign: TextAlign.center
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
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, 0.4),
            ),

            // book button
            Container(
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BookSession(context);
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
                  child: const Text('       Book         ', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.3, 0.6),
            ),

            // confirm to start button
            Container(
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ConfirmBookingDialog(context);
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
                  child: const Text('Confirm to Start', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.3, 0.8),
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
