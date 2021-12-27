import 'dart:io';
import 'package:facility_booking/Database/SettingsDB.dart';
import 'package:facility_booking/model/LocationModel.dart';
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


Future<Locations> fetchLocation() async {

  String Lkey = "23";
  FutureBuilder<List<Setting>>(
      future: getLkeyFromDB(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (snapshot.hasData) {
            Lkey = snapshot.data[0].Lkey;
            print(Lkey);
            return Text(Lkey);
          }
        }
        return Container(
          alignment: AlignmentDirectional.center,
          child: CircularProgressIndicator(),
        );
      }
  );

  final response = await http.get(
    Uri.parse('https://bobtest.optergykl.ga/lucy/location/v1/locations/$Lkey'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
    },
  );

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}