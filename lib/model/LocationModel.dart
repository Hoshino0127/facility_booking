class Locations {
  String address;
  String currency;
  String description;
  String floorSize;
  String geoMap;
  String locationCode;
  String locationFullName;
  String locationKey;
  String locationName;
  String locationType;
  String locationTypeKey;
  String mobilePrefix;
  String parentLocationFullName;
  String parentLocationKey;
  String secondName;
  String siteKey;
  String siteLocationFullName;
  String timeZone;

  Locations(
      {this.address,
        this.currency,
        this.description,
        this.floorSize,
        this.geoMap,
        this.locationCode,
        this.locationFullName,
        this.locationKey,
        this.locationName,
        this.locationType,
        this.locationTypeKey,
        this.mobilePrefix,
        this.parentLocationFullName,
        this.parentLocationKey,
        this.secondName,
        this.siteKey,
        this.siteLocationFullName,
        this.timeZone});

  Locations.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    currency = json['Currency'];
    description = json['Description'];
    floorSize = json['FloorSize'];
    geoMap = json['GeoMap'];
    locationCode = json['LocationCode'];
    locationFullName = json['LocationFullName'];
    locationKey = json['LocationKey'];
    locationName = json['LocationName'];
    locationType = json['LocationType'];
    locationTypeKey = json['LocationTypeKey'];
    mobilePrefix = json['MobilePrefix'];
    parentLocationFullName = json['ParentLocationFullName'];
    parentLocationKey = json['ParentLocationKey'];
    secondName = json['SecondName'];
    siteKey = json['SiteKey'];
    siteLocationFullName = json['SiteLocationFullName'];
    timeZone = json['TimeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['Currency'] = this.currency;
    data['Description'] = this.description;
    data['FloorSize'] = this.floorSize;
    data['GeoMap'] = this.geoMap;
    data['LocationCode'] = this.locationCode;
    data['LocationFullName'] = this.locationFullName;
    data['LocationKey'] = this.locationKey;
    data['LocationName'] = this.locationName;
    data['LocationType'] = this.locationType;
    data['LocationTypeKey'] = this.locationTypeKey;
    data['MobilePrefix'] = this.mobilePrefix;
    data['ParentLocationFullName'] = this.parentLocationFullName;
    data['ParentLocationKey'] = this.parentLocationKey;
    data['SecondName'] = this.secondName;
    data['SiteKey'] = this.siteKey;
    data['SiteLocationFullName'] = this.siteLocationFullName;
    data['TimeZone'] = this.timeZone;
    return data;
  }
}
