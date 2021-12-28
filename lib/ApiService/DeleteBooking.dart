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


Future<Booking> deleteBooking() async {

  final response = await http.delete(
    Uri.parse('https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings/1254'),
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