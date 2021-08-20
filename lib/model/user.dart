class User {
  bool status;
  String reason;
  Data data;

  User({this.status, this.reason, this.data});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reason = json['reason'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reason'] = this.reason;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String accessToken;
  int accessTokenExpAt;

  Data({this.accessToken, this.accessTokenExpAt});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExpAt = json['accessTokenExpAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['accessTokenExpAt'] = this.accessTokenExpAt;
    return data;
  }
}
