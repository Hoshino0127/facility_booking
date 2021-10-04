import 'package:facility_booking/ApiService/test.dart';
import 'package:facility_booking/screens/SignIn.dart';
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
  String resultString;
  double _height;
  double _width;

  String _setTime, _setTime2;

  String _hour, _minute, _time;
  String _hour2, _minute2, _time2;

  String dateTime;

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime2 = TimeOfDay(hour: 00, minute: 00);


  TextEditingController _timeController = TextEditingController();
  TextEditingController _time2Controller = TextEditingController();


  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime2,
    );
    if (picked != null)
      setState(() {
        selectedTime2 = picked;
        _hour2 = selectedTime2.hour.toString();
        _minute2 = selectedTime2.minute.toString();
        _time2 = _hour2 + ' : ' + _minute2;
        _time2Controller.text = _time2;
        _time2Controller.text = formatDate(
            DateTime(2019, 08, 1, selectedTime2.hour, selectedTime2.minute),
            [hh, ':', nn, " ", am]).toString();
      });
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
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        if(_time == null && _time2 == null ){
          NullTimeDialog(context);
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn(_time, _time2),
            ),);
        }
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Confirm Booking?"),
      content: Text("To commence meeting timely,15 minutes is required prior to complete booking confirmation.\n"
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


  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }
  void initState2() {
    _time2Controller.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }


  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    return Scaffold(

        appBar: AppBar(
        ),
        body: Center(
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



                  Container(
                    child: InkWell(
                      onTap: () {
                        DateTimeRangePicker(
                            startText: "From",
                            endText: "To",
                            doneText: "Yes",
                            cancelText: "Cancel",
                            interval: 5,
                            initialStartTime: DateTime.now(),
                            initialEndTime: DateTime.now().add(Duration(minutes: 30)),
                            mode: DateTimeRangePickerMode.dateAndTime,
                            minimumTime: DateTime.now().subtract(Duration(days: 5)),
                            maximumTime: DateTime.now().add(Duration(days: 25)),
                            use24hFormat: true,
                            onConfirm: (start, end) {
                              print(start);
                              print(end);
                            }).showPicker(context);
                      },
                      child: Container(

                        width: _width / 8,
                        height: _height / 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Start',
                          ),
                        ),
                      ),
                    ),
                    alignment: Alignment(-0.48, -0.1),
                  ),

                  // center box
                  Container(
                   child: Container(
                     margin: EdgeInsets.all(20),
                     height: 300,
                     width: 500,
                     decoration: BoxDecoration(
                       color: Colors.grey[200],
                       borderRadius: BorderRadius.circular(30), //border corner radius
                       boxShadow:[
                         BoxShadow(
                           color: Colors.white.withOpacity(0.5),//color of shadow
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
                    alignment: Alignment(-0.65, 0),
                  ),

                  // submit button
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(_time, _time2),
                          ),);
                       /* ConfirmBookingDialog(context);*/
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
                        child: const Text('Submit', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    alignment: Alignment(-0.48, 0.2),
                  ),

                  // cancel button
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => TestGet()
                        ));
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
                    alignment: Alignment(-0.15, 0.2),
                  ),

                  Container(
                    child: InkWell(
                      onTap: () {
                        DateTimeRangePicker(
                            startText: "From",
                            endText: "To",
                            doneText: "Yes",
                            cancelText: "Cancel",
                            interval: 5,
                            initialStartTime: DateTime.now(),
                            initialEndTime: DateTime.now().add(Duration(minutes: 30)),
                            mode: DateTimeRangePickerMode.dateAndTime,
                            minimumTime: DateTime.now().subtract(Duration(days: 5)),
                            maximumTime: DateTime.now().add(Duration(days: 25)),
                            use24hFormat: true,
                            onConfirm: (start, end) {
                              print(start);
                              print(end);
                            }).showPicker(context);
                      },
                      child: Container(
                        width: _width / 4,
                        height: _height / 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Pick Time and Date',
                          ),
                        ),
                      ),
                    ),
                    alignment: Alignment(-0.35, -0.1),
                  ),

                /*  //time 1
                  Container(
                    child: InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(

                        width: _width / 8,
                        height: _height / 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Start',
                              ),
                        ),
                      ),
                    ),
                    alignment: Alignment(-0.48, -0.1),
                  ),

                  // time 2
                  Container(
                    child: InkWell(
                      onTap: () {
                        _selectTime2(context);
                      },
                      child: Container(
                        width: _width / 8,
                        height: _height / 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                          onSaved: (String val2) {
                            _setTime2 = val2;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _time2Controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'End',
                             ),
                        ),
                      ),
                    ),
                    alignment: Alignment(-0.15, -0.1),
                  ),*/

                  // booking text
                  Container(
                    child: Text(
                        'Booking',
                        style: new TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    alignment: Alignment(-0.3, -0.3),
                  ),

                  // discussion text
                  Container(
                    child: Text(
                        'Discussion',
                        style: new TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    alignment: Alignment(-0.73, -0.1),
                  ),

                /*  Container(
                    child: Text(
                        '-',
                        style: new TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    alignment: Alignment(-0.28, -0.12),
                  ),*/


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


                ]
            )
        ),
      );
  }
}
