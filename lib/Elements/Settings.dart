import 'package:facility_booking/Settings/SettingsLogin.dart';
import 'package:flutter/material.dart';


class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  IconButton(
        icon: Icon(
          Icons.settings,
          color: Colors.blue,
          size: 80.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsLogin(),
            ),);
        },
      )
    );
  }
}
