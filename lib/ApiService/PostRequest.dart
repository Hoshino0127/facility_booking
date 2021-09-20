import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Future<SignIn> createBooking(String username) async {
  final http.Response response = await http.post(
    'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': username,
    }),
  );

  if (response.statusCode == 201) {
    return SignIn.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}


class SignIn {

  final String username;

  SignIn({this.username});

  factory SignIn.fromJson(Map<String, dynamic> json) {
    return SignIn(
      username: json['CreatedUserFullName'],
    );
  }
}