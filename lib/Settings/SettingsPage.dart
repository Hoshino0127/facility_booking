import 'dart:io';
import 'package:facility_booking/Database/SettingsDB.dart';
import 'package:facility_booking/main.dart';
import 'package:facility_booking/model/SettingsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

var _location = [
  "23",
];
var _BufferTime = [
  "15 Minutes",
  "30 Minutes",
  "45 Minutes",
];
var _BookingSlot = [
  "30 Minutes",
  "1 Hour",
];

class _SettingsPageState extends State<SettingsPage> {
  var _currentSelectedValue;
  var _currentSelectedTime;
  var _currentSelectedBooking;

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

  void initState3() {
    super.initState();
  }

  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SETTINGS',
          style: new TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(300, 20, 300, 0),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Location',
                  ),
                  isEmpty: _currentSelectedValue == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSelectedValue,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _currentSelectedValue = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _location.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            alignment: Alignment(0, -0.8),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(300, 20, 300, 0),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    hintText: 'Please select expense',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Buffer Time To Start Meeting',
                  ),
                  isEmpty: _currentSelectedTime == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSelectedTime,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _currentSelectedTime = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _BufferTime.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            alignment: Alignment(0, -0.5),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(300, 20, 300, 0),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    hintText: 'Please select expense',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Booking Slot',
                  ),
                  isEmpty: _currentSelectedBooking == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSelectedBooking,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _currentSelectedBooking = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _BookingSlot.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            alignment: Alignment(0, -0.2),
          ),

          /*   Container(
              padding: EdgeInsets.fromLTRB(300, 20, 300, 0),
            ),

*/
          Container(
            child: Container(
              margin: EdgeInsets.all(20),
              height: 100,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30), //border corner radius
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
            alignment: Alignment(0, 0.2),
          ),

          //time 1
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
            alignment: Alignment(-0.02, 0.18),
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
            alignment: Alignment(0.29, 0.18),
          ),

          Container(
            child: Text(
              'Room Operating \n Time',
              style: new TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            alignment: Alignment(-0.3, 0.18),
          ),

          // Confirm Button
          Container(
            child: RaisedButton(
              onPressed: () async {
                final String LKey = _currentSelectedValue;
                final String EndTime =  _time2Controller.text;
                final String BufferTime = _currentSelectedTime;
                final String BookingSlot = _currentSelectedBooking;
                var settings = Setting(id: 0, Lkey: LKey, EndTime: EndTime, BufferTime: BufferTime, BookingSlot: BookingSlot);
                DbManager.db.insertLKey(settings);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      MyHomePage()),
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
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xff00DBDD), Color(0xff4F7FFF)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                child: const Text('Submit', style: TextStyle(fontSize: 20)),
              ),
            ),
            alignment: Alignment(-0.2, 0.5),
          ),

          //cancel button
          Container(
            child: RaisedButton(
              onPressed: () {
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
                padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                child: const Text('Cancel', style: TextStyle(fontSize: 20)),
              ),
            ),
            alignment: Alignment(0.2, 0.5),
          ),
        ],
      )),
    );
  }
}
