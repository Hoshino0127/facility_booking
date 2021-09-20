import 'dart:io';
import 'package:facility_booking/inprogresspage/MeetingInProgress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ApiService/ApiFunction.dart' as api;



class CancelBooking extends StatefulWidget {


  @override
  _CancelBookingState createState() => _CancelBookingState();
}


class _CancelBookingState extends State<CancelBooking> {


  @override
  void initState() {
    super.initState();
  }

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
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'PENDING \n CONFIRMATION',
                  style: new TextStyle(
                      fontSize: 60,
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.9),
            ),

            // meeting room text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<api.Booking>(
                future: api.fetchBooking(),
                builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    return Text(snapshot.data.FacilityID,
                      style: new TextStyle(
                          fontSize: 60,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              alignment: Alignment(0, -0.4),
            ),

            // time text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  '12.30PM - 2.30PM',
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(0, -0.2),
            ),

            // description text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: FutureBuilder<api.Booking>(
                future: api.fetchBooking(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.Purpose,
                      style: new TextStyle(
                          fontSize: 30,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              alignment: Alignment(0, 0),
            ),

            // next meeting text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'Next Meeting : ',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment(0, 0.2),
            ),

            // time text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  '12.30pm - 3.30pm',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment(0, 0.3),
            ),

            // host text
            Container(
              margin: EdgeInsets.only(right: 300.0),
              width: double.infinity,
              child: Text(
                  'Hosted By John',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment(0, 0.4),
            ),

            // center box
            Container(
              child: Container(
                margin: EdgeInsets.all(20),
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30), //border corner radius
                  boxShadow:[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5), //color of shadow
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
              alignment: Alignment(-0.33, 1),
            ),

            // cancel text
            Container(
              child: Text(
                  'Are you sure you want \n to cancel your booking',
                  style: new TextStyle(
                    fontSize: 20,
                    color: Colors.grey,

                  ),
                  textAlign: TextAlign.center
              ),
              alignment: Alignment(-0.3, 0.7),
            ),

            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetingInProgress(),
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
                  padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                  child: const Text('Yes', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.36, 0.88),
            ),


            Container(
              child: RaisedButton(
                onPressed: () {

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
                      colors: <Color>[Color(0xffD3D3D3), Color(0xff9E9E9E)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(35, 12, 35, 12),
                  child: const Text('No', style: TextStyle(fontSize: 20)),
                ),
              ),
              alignment: Alignment(-0.18, 0.88),
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

            // settings
            Container(
              child: Icon(
                  Icons.info, color: Colors.black, size: 100.0
              ),
              alignment: Alignment(1,-0.5),
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

          ],
        ),
      )
    );
  }
}
