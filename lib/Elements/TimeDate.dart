import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class TimeDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM \n  kk:mm:ss').format(now);
    return Container(
        child: Text(
            formattedDate,
            style: new TextStyle(
              fontSize: 40,
              color: Colors.grey,
    )
    )
    );
  }
}
