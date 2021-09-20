import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Future<Login> loginUser() async {
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
    return Login.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


class Login {

  final String Username;

  Login({this.Username});

  factory Login.fromJson(Map<String, dynamic> json) {

    return Login(
        Username: json['CreatedUserFullName']
    );
  }
}