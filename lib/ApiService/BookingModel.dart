import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

class BookingModel {
  String bookingID;
  String bookingKey;
  String bookingTypeID;
  String bookingTypeKey;
  String cancelledDateTime;
  String cancelledUserFullName;
  String cancelledUserKey;
  String closedDateTime;
  String closedUserFullName;
  String closedUserKey;
  String completedTime;
  String confirmedUserFullName;
  String confirmedUserKey;
  String createdDateTime;
  String createdUserFullName;
  String createdUserKey;
  String description;
  String duration;
  String endDateTime;
  String facilityID;
  String facilityTypeID;
  String facilityTypeKey;
  String finalizedDateTime;
  String finalizedUserFullName;
  String finalizedUserKey;
  String hostObjectID;
  String hostObjectKey;
  String hostObjectType;
  String hostUserFullName;
  String hourlyRate;
  String isActive;
  String isApproved;
  String isAutoConfirmedtoStart;
  String isCancelled;
  String isConfirmedtoStart;
  String isFinalized;
  String locationFullName;
  String locationKey;
  String numberOfParticipants;
  String occupancy;
  String purpose;
  String ratingValue;
  String remarks;
  String requesterObjectID;
  String requesterObjectKey;
  String requesterObjectType;
  String seatingTypeKey;
  String seatingTypeName;
  String sentForApproval;
  String stage;
  String startDateTime;

  BookingModel(
      {this.bookingID,
        this.bookingKey,
        this.bookingTypeID,
        this.bookingTypeKey,
        this.cancelledDateTime,
        this.cancelledUserFullName,
        this.cancelledUserKey,
        this.closedDateTime,
        this.closedUserFullName,
        this.closedUserKey,
        this.completedTime,
        this.confirmedUserFullName,
        this.confirmedUserKey,
        this.createdDateTime,
        this.createdUserFullName,
        this.createdUserKey,
        this.description,
        this.duration,
        this.endDateTime,
        this.facilityID,
        this.facilityTypeID,
        this.facilityTypeKey,
        this.finalizedDateTime,
        this.finalizedUserFullName,
        this.finalizedUserKey,
        this.hostObjectID,
        this.hostObjectKey,
        this.hostObjectType,
        this.hostUserFullName,
        this.hourlyRate,
        this.isActive,
        this.isApproved,
        this.isAutoConfirmedtoStart,
        this.isCancelled,
        this.isConfirmedtoStart,
        this.isFinalized,
        this.locationFullName,
        this.locationKey,
        this.numberOfParticipants,
        this.occupancy,
        this.purpose,
        this.ratingValue,
        this.remarks,
        this.requesterObjectID,
        this.requesterObjectKey,
        this.requesterObjectType,
        this.seatingTypeKey,
        this.seatingTypeName,
        this.sentForApproval,
        this.stage,
        this.startDateTime});

  BookingModel.fromJson(Map<String, dynamic> json) {
    bookingID = json['BookingID'];
    bookingKey = json['BookingKey'];
    bookingTypeID = json['BookingTypeID'];
    bookingTypeKey = json['BookingTypeKey'];
    cancelledDateTime = json['CancelledDateTime'];
    cancelledUserFullName = json['CancelledUserFullName'];
    cancelledUserKey = json['CancelledUserKey'];
    closedDateTime = json['ClosedDateTime'];
    closedUserFullName = json['ClosedUserFullName'];
    closedUserKey = json['ClosedUserKey'];
    completedTime = json['CompletedTime'];
    confirmedUserFullName = json['ConfirmedUserFullName'];
    confirmedUserKey = json['ConfirmedUserKey'];
    createdDateTime = json['CreatedDateTime'];
    createdUserFullName = json['CreatedUserFullName'];
    createdUserKey = json['CreatedUserKey'];
    description = json['Description'];
    duration = json['Duration'];
    endDateTime = json['EndDateTime'];
    facilityID = json['FacilityID'];
    facilityTypeID = json['FacilityTypeID'];
    facilityTypeKey = json['FacilityTypeKey'];
    finalizedDateTime = json['FinalizedDateTime'];
    finalizedUserFullName = json['FinalizedUserFullName'];
    finalizedUserKey = json['FinalizedUserKey'];
    hostObjectID = json['HostObjectID'];
    hostObjectKey = json['HostObjectKey'];
    hostObjectType = json['HostObjectType'];
    hostUserFullName = json['HostUserFullName'];
    hourlyRate = json['HourlyRate'];
    isActive = json['IsActive'];
    isApproved = json['IsApproved'];
    isAutoConfirmedtoStart = json['IsAutoConfirmedtoStart'];
    isCancelled = json['IsCancelled'];
    isConfirmedtoStart = json['IsConfirmedtoStart'];
    isFinalized = json['IsFinalized'];
    locationFullName = json['LocationFullName'];
    locationKey = json['LocationKey'];
    numberOfParticipants = json['NumberOfParticipants'];
    occupancy = json['Occupancy'];
    purpose = json['Purpose'];
    ratingValue = json['RatingValue'];
    remarks = json['Remarks'];
    requesterObjectID = json['RequesterObjectID'];
    requesterObjectKey = json['RequesterObjectKey'];
    requesterObjectType = json['RequesterObjectType'];
    seatingTypeKey = json['SeatingTypeKey'];
    seatingTypeName = json['SeatingTypeName'];
    sentForApproval = json['SentForApproval'];
    stage = json['Stage'];
    startDateTime = json['StartDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookingID'] = this.bookingID;
    data['BookingKey'] = this.bookingKey;
    data['BookingTypeID'] = this.bookingTypeID;
    data['BookingTypeKey'] = this.bookingTypeKey;
    data['CancelledDateTime'] = this.cancelledDateTime;
    data['CancelledUserFullName'] = this.cancelledUserFullName;
    data['CancelledUserKey'] = this.cancelledUserKey;
    data['ClosedDateTime'] = this.closedDateTime;
    data['ClosedUserFullName'] = this.closedUserFullName;
    data['ClosedUserKey'] = this.closedUserKey;
    data['CompletedTime'] = this.completedTime;
    data['ConfirmedUserFullName'] = this.confirmedUserFullName;
    data['ConfirmedUserKey'] = this.confirmedUserKey;
    data['CreatedDateTime'] = this.createdDateTime;
    data['CreatedUserFullName'] = this.createdUserFullName;
    data['CreatedUserKey'] = this.createdUserKey;
    data['Description'] = this.description;
    data['Duration'] = this.duration;
    data['EndDateTime'] = this.endDateTime;
    data['FacilityID'] = this.facilityID;
    data['FacilityTypeID'] = this.facilityTypeID;
    data['FacilityTypeKey'] = this.facilityTypeKey;
    data['FinalizedDateTime'] = this.finalizedDateTime;
    data['FinalizedUserFullName'] = this.finalizedUserFullName;
    data['FinalizedUserKey'] = this.finalizedUserKey;
    data['HostObjectID'] = this.hostObjectID;
    data['HostObjectKey'] = this.hostObjectKey;
    data['HostObjectType'] = this.hostObjectType;
    data['HostUserFullName'] = this.hostUserFullName;
    data['HourlyRate'] = this.hourlyRate;
    data['IsActive'] = this.isActive;
    data['IsApproved'] = this.isApproved;
    data['IsAutoConfirmedtoStart'] = this.isAutoConfirmedtoStart;
    data['IsCancelled'] = this.isCancelled;
    data['IsConfirmedtoStart'] = this.isConfirmedtoStart;
    data['IsFinalized'] = this.isFinalized;
    data['LocationFullName'] = this.locationFullName;
    data['LocationKey'] = this.locationKey;
    data['NumberOfParticipants'] = this.numberOfParticipants;
    data['Occupancy'] = this.occupancy;
    data['Purpose'] = this.purpose;
    data['RatingValue'] = this.ratingValue;
    data['Remarks'] = this.remarks;
    data['RequesterObjectID'] = this.requesterObjectID;
    data['RequesterObjectKey'] = this.requesterObjectKey;
    data['RequesterObjectType'] = this.requesterObjectType;
    data['SeatingTypeKey'] = this.seatingTypeKey;
    data['SeatingTypeName'] = this.seatingTypeName;
    data['SentForApproval'] = this.sentForApproval;
    data['Stage'] = this.stage;
    data['StartDateTime'] = this.startDateTime;
    return data;
  }
}