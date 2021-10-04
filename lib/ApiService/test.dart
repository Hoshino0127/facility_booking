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
  String stringData;
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

  Future decodeData() async{
    final Map parsedData = await jsonDecode(stringData);
    print(parsedData.toString());
  }


  @override
  Widget build(BuildContext context) {
    String resultString;
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            child: Text("Open"),
            onPressed: () {
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
          ),
          Text(resultString ?? "")
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async
        {
          await getData().then((value) {
            print(value);
          });/*.whenComplete(() async{
            await decodeData();
          });*/
        },
      ),

    );
  }
}
