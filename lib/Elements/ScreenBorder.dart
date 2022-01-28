import 'package:flutter/material.dart';

class AvailableBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green, //                   <--- border color
          width: 7.0,
        ),
      ),
    );
  }
}

class PendingBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrangeAccent, //                   <--- border color
          width: 7.0,
        ),
      ),
    );
  }
}

class InProgressBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red, //                   <--- border color
          width: 7.0,
        ),
      ),
    );
  }
}

