import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

/*

Future<Booking> fetchBooking() async {
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings'),
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
*/

Future<List<Booking>> fetchBooking(http.Client client) async {
  final response = await http.get(
      Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      });
  return compute(parseBooking, response.body);
}

// A function that converts a response body into a List<Booking>.
List<Booking> parseBooking(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Booking>((json) => Booking.fromJson(json)).toList();
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
  /*Future<Booking> futureBooking;*/
   List<Booking> booking;


  @override
  void initState() {
    super.initState();
  
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
               child: FutureBuilder<List<Booking>>(
                  future: fetchBooking(http.Client()),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[Color(0xff4F7FFF), Color(0xff6700DD)],
                            ),
                          ),
                          child: Text('Booked',style: TextStyle(fontSize: 35.0,color: Colors.white,), textAlign: TextAlign.center)
                      );
                    }
                    else if (snapshot.hasError) {
                      return Text("",style: TextStyle(fontSize: 35.0, color: Colors.grey, ),);
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                )
              )
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


