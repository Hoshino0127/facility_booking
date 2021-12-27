import 'dart:io';
import 'package:facility_booking/Database/SettingsDB.dart';
import 'package:facility_booking/model/BookingModel.dart';
import 'package:facility_booking/model/SettingsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
Future<List<Setting>> getLkeyFromDB() async {
  Future<List<Setting>> key = DbManager.db.getSettings();
  return key;
}


Future<Booking> fetchBooking() async {


  FutureBuilder<List<Setting>>(
      future: getLkeyFromDB(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (snapshot.hasData) {
             String Lkey;
             Lkey = snapshot.data[0].Lkey;
             print(Lkey);
             return Text(Lkey,
               );
          }
        }
        return Container(
          alignment: AlignmentDirectional.center,
          child: CircularProgressIndicator(),
        );
      });
  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/1'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
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
