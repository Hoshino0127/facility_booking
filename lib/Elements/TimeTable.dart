import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Future<Booking> fetchBooking() async {
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/2'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'SC:epf:0109999a39c6f102',
    },
  );

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Booking.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


class Booking {

  final String FacilityID;
  final String Starttime;
  final String Endtime;
  final String Purpose;
  final String HostName;

  Booking({this.FacilityID, this.Starttime, this.Purpose, this.Endtime, this.HostName});

  factory Booking.fromJson(Map<String, dynamic> json) {

    return Booking(
        FacilityID: json['FacilityID'],
        Starttime: json['StartDateTime'],
        Purpose: json['Purpose'],
        Endtime: json['EndDateTime'],
        HostName: json['HostUserFullName']
    );
  }

}

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Future<Booking> futureBooking;

  @override
  void initState() {
    super.initState();
    futureBooking = fetchBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Table(
        defaultColumnWidth: FixedColumnWidth(200.0),
        border: TableBorder.all(color: Colors.grey,width: 2.0),
        children: [
          TableRow(
            children: [
              Text("11.00am",style: TextStyle(fontSize: 35.0, color: Colors.grey, ),),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.fill,
                child: FutureBuilder<Booking>(
                  future: futureBooking,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[Color(0xff4F7FFF), Color(0xff6700DD)],
                            ),
                          ),
                          child: Text('Booked',style: TextStyle(fontSize: 35.0,), textAlign: TextAlign.center)
                      );
                    }
                    else if (snapshot.hasError) {
                      return Text("",style: TextStyle(fontSize: 35.0, color: Colors.grey, ),);
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
          TableRow(
              children: [
                Text("11.30am",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
          TableRow(
              children: [
                Text("12.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
          TableRow(
              children: [
                Text("12.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
          TableRow(
              children: [
                Text("1.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
          TableRow(
              children: [
                Text("1.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
          TableRow(
              children: [
                Text("2.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                Text("",style: TextStyle(fontSize: 50.0),),
              ]
          ),
        ],
      ),
    );
  }
}

