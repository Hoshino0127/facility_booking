import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class TestGet extends StatefulWidget {
  @override
  _TestGetState createState() => _TestGetState();
}

class _TestGetState extends State<TestGet> {
 /* String stringData;
  Future getData() async{
    var dio = new Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options){
      var headers = {
        HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
        'Content-Type': 'application/json',
      };
      options.headers.addAll(headers);
      return options.data;
    }
    ));
   Response response = await dio.get('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings');
   setState(() {
     stringData = response.data.toString();
   });
  return response.data;
  }
*/
  DateTime date;
  TimeOfDay time;
  DateTime dateTime;

  Future<DateTime> pickDate(BuildContext context) async{
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
    );
    if(newDate == null) return null;
    return newDate;
  }


  Future<TimeOfDay> pickTime(BuildContext context) async{
    final initialTime = TimeOfDay(hour: 00, minute: 00);
    final newTime = await showTimePicker(context: context,
        initialTime: dateTime != null ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute) : initialTime,);
    if (newTime == null) return null;
    return newTime;
  }

  Future pickDateTime(BuildContext context)async{
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getText(){
    if(dateTime == null){
      return 'Select Date and Time';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Center(
        child: Stack(
            children: <Widget>[
              TextButton(onPressed: () =>
                  pickDateTime(context).then((value) =>
                      print(dateTime)), child: Text(getText())),

             Container(
              child: Container(
                decoration: const BoxDecoration(
                 color: Colors.white,
                ),
                child:  TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: Text('Gradient'),
                ),
              ),
               alignment: Alignment(1,1),
             ),


            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async
        {
        /*  await getData().then((value) {
            print(value);
          });.whenComplete(() async{
            await decodeData();
          });*/
        },
      ),

    );
  }
}

