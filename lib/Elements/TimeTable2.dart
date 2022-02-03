import 'dart:io';
import 'package:facility_booking/Database/SettingsDB.dart';
import 'package:facility_booking/inprogresspage/MeetingInProgress.dart';
import 'package:facility_booking/inprogresspage/SignInProgress.dart';
import 'package:facility_booking/model/BookingModel.dart';
import 'package:facility_booking/model/SettingsModel.dart';
import 'package:facility_booking/pendingpage/Ready.dart';
import 'package:facility_booking/pendingpage/SignInCancel.dart';
import 'package:facility_booking/screens/bookingtime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:facility_booking/Elements/Constants.dart' as Constant;

final now = new DateTime.now();

String dateFormatter = DateFormat('yyyy-MM-dd').format(now);
String timeFormatter = DateFormat('hh:mm:ss').format(now);
String time11 = "${dateFormatter}T11:00:00Z";
String time1130 = "${dateFormatter}T11:30:00Z";
String time12 = "${dateFormatter}T12:00:00Z";
String time1230 = "${dateFormatter}T12:30:00Z";
String time13 = "${dateFormatter}T13:00:00Z";
String time1330 = "${dateFormatter}T13:30:00Z";
String time14 = "${dateFormatter}T14:00:00Z";
String time1430 = "${dateFormatter}T14:30:00Z";

final Color colorPending = Colors.deepOrangeAccent;
final Color colorFinalized = Color(0xFF2E368F);
final Color colorInProgress = Colors.red;


//https://stackoverflow.com/questions/60705340/how-to-round-time-to-the-nearest-quarter-hour-in-dart-and-flutter
//Extension for converting the current time to the nearest time interval
extension on DateTime{

  DateTime roundDown({Duration delta = const Duration(seconds: 15)}){
    return DateTime.fromMillisecondsSinceEpoch(
        this.millisecondsSinceEpoch -
            this.millisecondsSinceEpoch % delta.inMilliseconds
    );
  }
}

class TimeTable2 extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable2> {
  Future<List<Booking>> futureBooking;
  Future<List<String>> timeSlotsList;

  List<Setting> settings;
  String Bkey;
  String a = Constant.Location_Key;
  String userKey = Constant.User_Key;


  int bookingSlotsTimeRange = 0;
  int xTotal = 0;

  Future<int> getBookingCount() async {
    int xTotal = 0;
    String nowDate = dateFormatter + "T" + timeFormatter + "Z";
    String endDate = dateFormatter + "T23:59:59Z";

    final response = await http.get(
      //get the response with max=1 to reduce the API load
      Uri.parse(
          'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings?LocationKey=$a&StartDateTime=$nowDate&EndDateTime=$endDate&max=1'
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
      },
    );

    if (response.statusCode == 200) {
      if (response.headers['X-Total-Count'] != "") {
        xTotal = int.parse(response.headers['X-Total-Count']);
      }
    }

    return xTotal;
  }

  Future<List<String>> getTimeSlots() async{
    //settings = await DbManager.db.getSettings();
    NumberFormat formatter = new NumberFormat("00");
    List<String> timeSlots = [];
    List<Setting> testing = await DbManager.db.getSettings();
    print("Testing " + testing.toString() + "Count " + testing.length.toString());
    List<Setting> locationSettings = await DbManager.db.getSettingsByKey(Constant.Location_Key);
    String bookingSlotFound = "";
    String endTimeFound = "";

    if (locationSettings != null){
      print("Settings " + locationSettings.toString());
      bookingSlotFound = locationSettings[0].BookingSlot;
      endTimeFound = locationSettings[0].EndTime;
    }

    bookingSlotsTimeRange = 60;
    if(bookingSlotFound != ""){
      if (bookingSlotFound == "1 Hour"){
        bookingSlotsTimeRange = 60;
      }else{
        bookingSlotsTimeRange = 30;
      }
    }

    String strEndTime = "${dateFormatter}T23:59:00Z";
    if(endTimeFound != ""){
      //split the time to hours and minutes for formatting
      int hour = int.parse(endTimeFound.substring(0,2));
      int minute = int.parse(endTimeFound.substring(3,5));
      String ampm = endTimeFound.substring(6,8);

      //12 hour format to 24 hour
      if(ampm == "PM"){
        hour += 12;
      }

      strEndTime = "${dateFormatter}T${formatter.format(hour)}:${formatter.format(minute)}:00Z";
      //print(strEndTime);
    }
    DateTime currentTime = DateTime.now().roundDown(delta: Duration(minutes: bookingSlotsTimeRange));
    DateTime endTime = DateTime.parse(strEndTime);

    //print(endTime.toString());
    do{
      timeSlots.add(currentTime.toString());
      currentTime = currentTime.add(Duration(minutes: bookingSlotsTimeRange));

    }while ((currentTime).compareTo(endTime) < 0);


    return timeSlots;
  }

  Future<List<Booking>> fetchBooking() async {
    //xTotal = await getBookingCount();
    xTotal = 10;

    DateTime currentTime = DateTime.now().roundDown(delta: Duration(minutes: 60));
    String nowDate = dateFormatter + "T" + DateFormat("hh:mm:ss").format(currentTime) + "Z";
    String endDate = dateFormatter + "T23:59:59Z";
    var response = await http.get(
        Uri.parse(
            'https://bobtest.optergykl.ga/lucy/facilitybooking/v1/bookings?LocationKey=$a&StartDateTime=$nowDate&EndDateTime=$endDate&max=$xTotal'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: 'SC:epf:8425db95834f9c7f',
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Booking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  PendingDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Confirm Booking"),
      onPressed: () {
        print(Bkey);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadyToStart(Bkey),
          ),
        );
      },
    );
    Widget continueButton = TextButton(
      child: Text("Cancel Booking"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInCancel(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text(
          "Would you like to confirm or cancel current selected booking??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  BookedDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInCancel(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text("Would you like to cancel current selected booking??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  InProgressDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInProgress(Bkey),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose your action"),
      content: Text("Would you like to view current selected booking??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool checkTime(DateTime currentTime, DateTime startTime, DateTime endTime){

    int currentStartTimeMin = currentTime.hour * 60 + currentTime.minute;
    int currentEndTimeMin = currentTime.hour * 60 + currentTime.minute + bookingSlotsTimeRange;
    int startTimeMin = startTime.hour * 60 + startTime.minute;
    int endTimeMin = endTime.hour * 60 + endTime.minute;

    if (startTimeMin < currentEndTimeMin && endTimeMin > currentStartTimeMin){
      //print("s " + startTimeMin.toString() + ",csm " + currentStartTimeMin.toString() + ",e " + endTimeMin.toString() + ",cem " + currentEndTimeMin.toString());
      return true;
    }
    return false;
  }

  callDialogs(BuildContext context, String status, String bookingKey, String hostObjectKey, DateTime startTime, DateTime endTime){

    DateTime currentStartTime;
    DateTime currentEndTime;
    DateTime selectedStartTime;
    DateTime selectedEndTime;
    bool isFound = false;

    //set the current booking key to BKey for further actions
    setState(() {
      Bkey = bookingKey;
    });

    //when the slot is available
    if(status == ""){

      //start of select/deselect timeslots
      if(Constant.selectedDateTimeList.length != 0){
        for(int i = 0; i < Constant.selectedDateTimeList.length; i++){
          Map<String,DateTime> selectedDateTime = Constant.selectedDateTimeList[i];
          selectedStartTime = selectedDateTime['startTime'];
          selectedEndTime = selectedDateTime['endTime'];

          if(currentStartTime != null && currentEndTime != null){
            if(selectedStartTime.compareTo(currentStartTime) < 0){
              currentStartTime = selectedStartTime;
            }

            if(selectedEndTime.compareTo(currentEndTime) > 0){
              currentEndTime = selectedEndTime;
            }
          }else{
            currentStartTime = selectedStartTime;
            currentEndTime = selectedEndTime;
          }

        }

        //after knowing the current start and end, see if the selected one is before or after the selection
        //if before, set the currentStartTime earlier
        if(startTime.compareTo(currentStartTime) < 0){
          currentStartTime = startTime;
        }else{
          if(endTime.isBefore(currentEndTime)){
            currentStartTime = endTime;
          }
        }

        //if after, set the currentEndTime later
        if(endTime.compareTo(currentEndTime) > 0){
          currentEndTime = endTime;
        }else{
          if(startTime.isAfter(currentStartTime)){
            currentEndTime = startTime;
          }
        }

        //deselect the last timeslot
        if(Constant.selectedDateTimeList.length == 1
            && Constant.selectedDateTimeList[0]['startTime'] == startTime
            && Constant.selectedDateTimeList[0]['endTime'] == endTime ){
          Constant.selectedDateTimeList.clear();
          currentStartTime = null;
          currentEndTime = null;
        }else{
          DateTime startTimeDoWhile = currentStartTime;
          Constant.selectedDateTimeList.clear(); //reset list
          do{
            Map<String, DateTime> dtMap = {};
            dtMap['startTime'] = startTimeDoWhile;
            dtMap['endTime'] = startTimeDoWhile.add(new Duration(minutes: bookingSlotsTimeRange));
            Constant.selectedDateTimeList.add(dtMap);
            startTimeDoWhile = startTimeDoWhile.add(new Duration(minutes: bookingSlotsTimeRange));
          }while((startTimeDoWhile).compareTo(currentEndTime) < 0);
        }

      }else{
        currentStartTime = startTime;
        currentEndTime = endTime;

        Map<String, DateTime> dtMap = {};
        dtMap['startTime'] = startTime;
        dtMap['endTime'] = endTime;
        Constant.selectedDateTimeList.add(dtMap);
      }


      print("Current start time: " + currentStartTime.toString());
      print("Current end time: " + currentEndTime.toString());
      print(Constant.selectedDateTimeList);

      //end of select/deselect timeslots

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingTime(startTime: currentStartTime, endTime: currentEndTime,),
        ),);
    }else{
      if(hostObjectKey == userKey){
        if(status == "Pending"){
          PendingDialog(context);
        }else if(status == "Finalized"){
          BookedDialog(context);
        }else if(status == "In Progress"){
          InProgressDialog(context);
        }
      }else{
        //only allow to view details
      }
    }



  }

  @override
  void initState() {
    super.initState();

    //currently userKey retrieval is still under development, so the userKey is hardcoded for now
    //later, a function will be created to get the userKey of the current login user
    //print(DbManager.db.deleteSettings().toString());
    userKey = "1";
    timeSlotsList = getTimeSlots();
    futureBooking = fetchBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: FutureBuilder<List<String>>(
        future: timeSlotsList,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if(!snapshot.hasData){
              return Container(
                child: Text(
                  "No time slots found",
                  style: TextStyle(fontSize: 30.0, color: Colors.black,),
                ),
              );

            }
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  DateTime currentTime = DateTime.parse(snapshot.data[index].toString());
                  DateTime startTime;
                  DateTime endTime;
                  String stage;
                  String hostObjectKey = "";
                  String bookingKey = "";
                  String statusText = "";
                  Color statusColor = Colors.white;

                  bool isSelected = false;

                  return FutureBuilder<List<Booking>>(
                    future: futureBooking,
                    builder: (context, bookingSnapshot){
                      if(bookingSnapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child:Text(
                              "Waiting"
                          ),
                        );
                      }else{

                        if(!bookingSnapshot.hasData){
                          return Container(
                            child: new Row(
                              children: [
                                new Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      width: 200,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey[400])
                                      ),
                                      child: Text(
                                        toDateTimePeriodFromUtcIso8601String(currentTime.toString()),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        for(int i = 0; i <= bookingSnapshot.data.length - 1; i++){

                          startTime = DateTime.parse(
                              bookingSnapshot
                                  .data[i].startDateTime
                                  .toString()
                          );
                          endTime = DateTime.parse(
                              bookingSnapshot
                                  .data[i].endDateTime
                                  .toString()
                          );
                          stage = bookingSnapshot
                              .data[i].stage
                              .toString();

                          if(stage == "Pending" || stage =="Finalized" || stage =="InProgress"){

                            if (checkTime(currentTime, startTime, endTime)){

                              hostObjectKey = bookingSnapshot
                                  .data[i].hostObjectKey;

                              bookingKey = bookingSnapshot
                                  .data[i].bookingKey
                                  .toString();


                              switch(stage){
                                case 'Pending':{
                                  statusText = "Pending";
                                  statusColor = colorPending;
                                }
                                break;

                                case 'Finalized':{
                                  statusText = "Finalized";
                                  statusColor = colorFinalized;
                                }
                                break;

                                case 'InProgress':{
                                  statusText = "In Progress";
                                  statusColor = colorInProgress;
                                }
                                break;
                              }
                            }
                          }
                          if(statusText == ""){
                            for(int i = 0; i < Constant.selectedDateTimeList.length; i++) {
                              Map<String, DateTime> selectedDateTime = Constant
                                  .selectedDateTimeList[i];
                              DateTime selectedStartTime = selectedDateTime['startTime'];
                              DateTime selectedEndTime = selectedDateTime['endTime'];

                              if(selectedStartTime == currentTime){

                                statusColor = Colors.grey;

                              }
                            }
                          }
                        }
                        return Container(
                          child: new Row(
                            children: [
                              new Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(30),
                                    width: 200,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey[400])
                                    ),
                                    child: Text(
                                      toDateTimePeriodFromUtcIso8601String(currentTime.toString()),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                ],
                              ),
                              new Column(
                                children: [
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(30),
                                      color: statusColor,
                                      width: 200,
                                      height: 100,
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () {
                                      // setState(() {
                                      //   isSelected = isSelected != true;
                                      // });
                                      callDialogs(
                                          context,
                                          statusText,
                                          bookingKey,
                                          hostObjectKey,
                                          currentTime,
                                          currentTime.add(new Duration(minutes: bookingSlotsTimeRange))
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          }

        },
      ),
      alignment: Alignment(0.98, 0.95),
    );
  }
}



String toDateTimePeriodFromUtcIso8601String(String dateTime) {
  var strToDateTime = DateTime.parse(dateTime);
  final convertLocal = strToDateTime.toLocal();
  final DateFormat formatter = DateFormat('HH:mm');
  final String formatted = formatter.format(convertLocal);
  return formatted;
}