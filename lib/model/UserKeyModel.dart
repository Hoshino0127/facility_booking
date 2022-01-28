class UserKeyModel {
  String aPIKey;
  int userKey;

  UserKeyModel({this.aPIKey, this.userKey});

  UserKeyModel.fromJson(Map<String, dynamic> json) {
    aPIKey = json['APIKey'];
    userKey = json['UserKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['APIKey'] = this.aPIKey;
    data['UserKey'] = this.userKey;
    return data;
  }
}