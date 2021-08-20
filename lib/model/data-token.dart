class DataToken {
  String accessToken;
  int accessTokenExpAt;

  DataToken({this.accessToken, this.accessTokenExpAt});

  DataToken.fromJson(Map<String, dynamic> json) {
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