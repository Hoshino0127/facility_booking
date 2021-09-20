import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Booking> fetchBooking() async {
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/1'),
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
