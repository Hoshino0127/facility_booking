import 'package:facility_booking/main.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:  IconButton(
          icon: Icon(
            Icons.home,
            color: Color(0xFF2E368F),
            size: 80.0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),);
          },
        ),
            alignment: Alignment(-1,0.85),
    );
  }
}