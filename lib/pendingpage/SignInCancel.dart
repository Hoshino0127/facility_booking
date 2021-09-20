import 'package:facility_booking/pendingpage/CancelBooking.dart';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInCancel extends StatefulWidget {
  @override
  _SignInCancelState createState() => _SignInCancelState();
}

class _SignInCancelState extends State<SignInCancel> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM \n  kk:mm:ss').format(now);
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            // pending confirmation text
            Container(
              child: Text(
                  'PENDING \n CONFIRMATION',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(-0.6, -0.9),
            ),

            // center box
            Container(
              child: Container(
                margin: EdgeInsets.all(20),
                height: 300,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30), //border corner radius
                  boxShadow:[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),//color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                    //you can set more BoxShadow() here
                  ],
                ),
              ),
              alignment: Alignment(-0.65, 0),
            ),

            //please sign in text
            Container(
              child: Text(
                  'Please Sign-In',
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
              alignment: Alignment(-0.45, -0.3),
            ),

            // username text field
            Container(
              padding: EdgeInsets.fromLTRB(180, 12, 670, 12),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
              alignment: Alignment(-0.8, -0.1),
            ),

            // password textfield
            Container(
              padding: EdgeInsets.fromLTRB(180, 12, 670, 12),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              alignment: Alignment(-0.8, 0.15),
            ),

            // submit button
            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CancelBooking()
                    ),);
                },
                textColor: Colors.white,
                padding : EdgeInsets.fromLTRB(0,0,0,0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xff00DBDD), Color(0xff4F7FFF)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                  child: const Text('Confirm', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.2, 0.36),
            ),


            // time table
            Container(
              child: Table(
                defaultColumnWidth: FixedColumnWidth(200.0),
                border: TableBorder.all(color: Colors.grey,width: 2.0),
                children: [
                  TableRow(
                      children: [
                        Text("11.00am",style: TextStyle(fontSize: 35.0, color: Colors.grey, ),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("11.30am",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("12.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("1.30pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("2.00pm",style: TextStyle(fontSize: 35.0, color: Colors.grey,),),
                        Text("",style: TextStyle(fontSize: 50.0),),
                      ]
                  ),
                ],
              ),
              alignment: Alignment(1, 1),
            ),

            // time and date
            Container(
              child: Text(
                  formattedDate,
                  style: new TextStyle(
                    fontSize: 40,
                    color: Colors.grey,

                  )
              ),
              alignment: Alignment(1,-1),
            ),

            //settings
            Container(
              child: Icon(
                  Icons.info, color: Colors.black, size: 100.0
              ),
              alignment: Alignment(1,-0.5),
            ),

          ],
        ),
      ),
    );
  }
}
