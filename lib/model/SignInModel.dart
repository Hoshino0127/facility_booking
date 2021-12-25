class SignInModel {
  String userKey;
  String loginID;
  String firstName;
  String lastName;
  String displayName;
  String legalName;
  String phone;
  String email;
  String officePhone;
  String userType;
  String userGroupKey;
  String userGroupID;
  String siteKey;
  String siteLocationFullName;
  String timeFormat;
  String dateFormat;
  String currencyFormat;
  String language;
  String identificationNumber;
  String isLoginDisabled;
  String lastLoginDate;
  String hidden;

  SignInModel(
      {this.userKey,
        this.loginID,
        this.firstName,
        this.lastName,
        this.displayName,
        this.legalName,
        this.phone,
        this.email,
        this.officePhone,
        this.userType,
        this.userGroupKey,
        this.userGroupID,
        this.siteKey,
        this.siteLocationFullName,
        this.timeFormat,
        this.dateFormat,
        this.currencyFormat,
        this.language,
        this.identificationNumber,
        this.isLoginDisabled,
        this.lastLoginDate,
        this.hidden});

  SignInModel.fromJson(Map<String, dynamic> json) {
    userKey = json['UserKey'];
    loginID = json['LoginID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    displayName = json['DisplayName'];
    legalName = json['LegalName'];
    phone = json['Phone'];
    email = json['Email'];
    officePhone = json['OfficePhone'];
    userType = json['UserType'];
    userGroupKey = json['UserGroupKey'];
    userGroupID = json['UserGroupID'];
    siteKey = json['SiteKey'];
    siteLocationFullName = json['SiteLocationFullName'];
    timeFormat = json['TimeFormat'];
    dateFormat = json['DateFormat'];
    currencyFormat = json['CurrencyFormat'];
    language = json['Language'];
    identificationNumber = json['IdentificationNumber'];
    isLoginDisabled = json['IsLoginDisabled'];
    lastLoginDate = json['LastLoginDate'];
    hidden = json['Hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserKey'] = this.userKey;
    data['LoginID'] = this.loginID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['DisplayName'] = this.displayName;
    data['LegalName'] = this.legalName;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['OfficePhone'] = this.officePhone;
    data['UserType'] = this.userType;
    data['UserGroupKey'] = this.userGroupKey;
    data['UserGroupID'] = this.userGroupID;
    data['SiteKey'] = this.siteKey;
    data['SiteLocationFullName'] = this.siteLocationFullName;
    data['TimeFormat'] = this.timeFormat;
    data['DateFormat'] = this.dateFormat;
    data['CurrencyFormat'] = this.currencyFormat;
    data['Language'] = this.language;
    data['IdentificationNumber'] = this.identificationNumber;
    data['IsLoginDisabled'] = this.isLoginDisabled;
    data['LastLoginDate'] = this.lastLoginDate;
    data['Hidden'] = this.hidden;
    return data;
  }
}
